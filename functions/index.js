const functions = require('firebase-functions');
const admin = require('firebase-admin');
const {CloudTasksClient} = require('@google-cloud/tasks');
admin.initializeApp();
const logger = require("firebase-functions/logger");
const cors = require('cors')({origin: true});
const moment = require('moment-timezone');



exports.createPostReminderTask = functions.region('asia-east1').https.onRequest(async (req, res) => {
  cors(req, res, async() => {
    if (req.method !== 'POST') {
      res.status(405).send('Method Not Allowed');
      return;
    }
  
    const { postId, title, text } = req.body;
  
    if (!postId || !title || !text) {
        res.status(400).send('Missing required fields');
        return;
    }
  
    try {
        // 假设您已经从请求中提取了提醒的时间
        const remindDateTimeStr = req.body.remindDateTime;
        // 解析日期时间字符串并确保以特定时区（例如台湾时区）来处理
        const remindDateTime = moment.tz(remindDateTimeStr, "Asia/Taipei").toDate();
      
        const scheduleTime = new Date(remindDateTime);
  
        const client = new CloudTasksClient();
  
        const project = 'upoint-d4fc3';
        const queue = 'upoint-remind';
        const location = 'asia-east1';
        const url = `https://${location}-${project}.cloudfunctions.net/sendReminderNotification`;
        const payload = { postId, title, text };
  
        const task = {
            httpRequest: {
                httpMethod: 'POST',
                url,
                body: Buffer.from(JSON.stringify(payload)).toString('base64'),
                headers: {
                    'Content-Type': 'application/json',
                },
            },
            scheduleTime: {
                seconds: scheduleTime / 1000,
            },
        };
  
        await client.createTask({
            parent: client.queuePath(project, location, queue),
            task,
        });
  
        logger.info('Task created:', postId, remindDateTime);
        res.status(200).send('Task created successfully');
    } catch (error) {
        logger.error('Failed to create task:', error);
        res.status(500).send('Failed to create task');
    }
  })
});

  exports.sendReminderNotification = functions.region('asia-east1').https.onRequest(async (req, res) => {
    try {
      // 从请求体中解析出 postId
      const { postId, title, text } = req.body;

      // 获取报名了这个帖子的用户
      const subscribersSnapshot = await admin.firestore()
          .collection("posts")
          .doc(postId)
          .collection('signForms')
          .get();

      const tokens = [];
      subscribersSnapshot.forEach(doc => {
          const subscriber = doc.data();
          const subscriberTokens = subscriber.fcmToken;
          if (Array.isArray(subscriberTokens)) {
              tokens.push(...subscriberTokens);
          }
      });
      logger.info(`token llength: ${tokens.length}`)

      if (tokens.length > 0) {
          // 发送 FCM 通知
          const message = {
              notification: {
                  title: title,
                  body: text,
              },
              tokens: tokens,
          };

          const response = await admin.messaging().sendMulticast(message);
          logger.info(`Successfully sent message: ${response}`);
          res.status(200).send(`Successfully sent message: ${response}`);
      } else {
          logger.info("No subscribers found for this post.");
          res.status(200).send("No subscribers found for this post.");
      }
  } catch (error) {
      // 如果发生错误，记录错误并返回500错误响应
      logger.error(`Error sending reminder notification: ${error}`);
      res.status(500).send(`Error sending reminder notification: ${error}`);
  }
});

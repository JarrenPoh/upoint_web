const functions = require('firebase-functions');
const admin = require('firebase-admin');
const {CloudTasksClient} = require('@google-cloud/tasks');
admin.initializeApp();
const logger = require("firebase-functions/logger");
const cors = require('cors')({origin: true});
const moment = require('moment-timezone');
const { v1: uuidv1 } = require('uuid');



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
      const inboxPromises = []; // 用于存放向用户 inbox 存储信息的 promises
      subscribersSnapshot.forEach(doc => {
          const subscriber = doc.data();
          const subscriberTokens = subscriber.fcmToken;
          const subscriberUid = subscriber.uuid;
          if (Array.isArray(subscriberTokens)) {
              tokens.push(...subscriberTokens);
          }

           // 创建存储到用户 inbox 的 promise
          const inboxPromise = admin.firestore()
           .collection("users")
           .doc(subscriberUid)
           .collection("inboxs")
           .add({
               datePublished: admin.firestore.FieldValue.serverTimestamp(),
               name: "優碰客服",
               inboxId: uuidv1(),
               uid: "tvRc40ekeeY5UTiPist8qVRm0m92",
               pic: "https://firebasestorage.googleapis.com/v0/b/upoint-d4fc3.appspot.com/o/upoint_logo.png?alt=media&token=c75e3644-e86d-47cf-82d6-2becb27f8d25",
               text: text,
               url: `https://upoint.tw/activity?id=${postId}`,
           });
          inboxPromises.push(inboxPromise);
      });
      logger.info(`token llength: ${tokens.length}`)
      // 等待所有的 inbox 信息被存储
      await Promise.all(inboxPromises);

      if (tokens.length > 0) {
          // 发送 FCM 通知
          const message = {
              notification: {
                  title: title,
                  body: text,
              },
              tokens: tokens,
              data:{
                click_action: "FLUTTER_NOTIFICATION_CLICK",
                id: "2",
                status: "done",
                open_link: `https://upoint.tw/activity?id=${postId}`,
              }
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

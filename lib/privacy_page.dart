import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';

class PrivacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MediumText(color: Colors.white, size: 20, text: '隱私權保護政策'),
        backgroundColor: primaryColor, // 可以根據您的需求調整顏色
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MediumText(color: Colors.black, size: 24, text: '隱私權保護政策'),
            SizedBox(height: 16),
            MediumText(
              color: Colors.black,
              size: 16,
              text: '「UPoint」是由「UPoint開發團隊」（下稱我們）所經營之APP(下稱本APP)各項服務與資訊。以下是我們的隱私權保護政策，幫助您瞭解本APP所蒐集的個人資料之運用及保護方式。',
            ),
            SizedBox(height: 16),
            _buildSectionTitle('一、隱私權保護政策的適用範圍'),
            _buildSectionContent(
              '（1）請您在於使用本APP服務前，確認您已審閱並同意本隱私權政策所列全部條款，若您不同意全部或部份者，則請勿使用本APP服務。',
            ),
            _buildSectionContent(
              '（2）隱私權保護政策內容，包括我們如何處理您在使用本APP服務時蒐集到的個人識別資料。',
            ),
            _buildSectionContent(
              '（3）隱私權保護政策不適用於本APP以外的相關連結網站，亦不適用於非我們所委託或參與管理之人員。',
            ),
            SizedBox(height: 16),
            _buildSectionTitle('二、個人資料的蒐集及使用'),
            _buildSectionContent(
              '（1）於一般瀏覽時，伺服器會自行記錄相關行徑，包括您使用連線設備的IP位址、使用時間、使用的瀏覽器、瀏覽及點選資料記錄等，做為我們增進服務的參考依據，此記錄為內部應用，絕不對外公布。',
            ),
            _buildSectionContent(
              '（2）在使用我們的服務時，我們可能會要求您向我們提供可用於聯繫或識別您的某些個人資料，包括：',
            ),
            _buildBulletList([
              'C001辨識個人者： 如姓名、電子郵件等資訊。',
              'C011個人描述：例如：性別、出生年月日等。',
              'C051學校紀錄。',
            ]),
            _buildSectionContent(
              '（3）本APP將蒐集的數據用於各種目的：',
            ),
            _buildBulletList([
              '提供和維護系統所提供的服務',
              '提供用戶支持',
              '提供分析或有價值訊息，以便我們改進服務',
              '監控服務的使用情況',
              '檢測，預防和解決技術問題',
            ]),
            _buildSectionContent(
              '（4）本APP針對蒐集數據的利用期間、地區、對象及方式：',
            ),
            _buildBulletList([
              '期間：當事人要求停止使用或本服務停止提供服務之日為止。',
              '地區：個人資料將用於台灣地區。',
              '利用對象及方式：所蒐集到的資料將利用於各項業務之執行，利用方式為因業務執行所必須進行之各項分析、聯繫及通知。',
            ]),
            SizedBox(height: 16),
            _buildSectionTitle('三、資料的保護與安全'),
            _buildSectionContent(
              '（1）本APP主機均設有防火牆、防毒系統等相關資訊安全設備及必要的安全防護措施，本APP及您的個人資料均受到嚴格的保護。只有經過授權的人員才能接觸您的個人資料，相關處理人員均有簽署保密合約，如有違反保密義務者，將會受到相關的法律處分。',
            ),
            //... 持續增加其他段落和內容
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return MediumText(color: Colors.black, size: 20, text: title);
  }

  Widget _buildSectionContent(String content) {
    return MediumText(color: Colors.black, size: 16, text: content);
  }

  Widget _buildBulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) => MediumText(color: Colors.black, size: 16, text: '• $item')).toList(),
    );
  }
}

// 假設的自定義MediumText組件
class MediumText extends StatelessWidget {
  final Color color;
  final double size;
  final String text;

  MediumText({required this.color, required this.size, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: size),
    );
  }
}

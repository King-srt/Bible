import '../models/character.dart';
import '../models/localized_text.dart';
import '../models/story.dart';
import '../models/testament.dart';
import 'bible_repository.dart';

class MockBibleRepository implements BibleRepository {
  MockBibleRepository();

  final List<Story> _stories = const [
    Story(
      id: 'story_jesus_feeds_5000',
      title: LocalizedText(
        en: 'Jesus Feeds the Five Thousand',
        id: 'Yesus Memberi Makan Lima Ribu Orang',
      ),
      content: LocalizedText(
        en: 'A large crowd followed Jesus because they had seen His healing and heard His teaching. As evening approached, the disciples became concerned because the people were far from town and had nothing to eat.\n\nJesus did not send them away hungry. Instead, He asked the disciples what was available. They found five loaves of bread and two fish, which seemed far too little for such a great crowd.\n\nJesus took the loaves and fish, gave thanks, and told the disciples to distribute them. As they obeyed, the food was multiplied. Everyone ate until they were satisfied, and twelve baskets of leftovers were gathered afterward.\n\nThis story shows that Jesus sees both spiritual and practical needs. He teaches with compassion, provides with abundance, and invites His followers to trust Him even when their resources seem small.',
        id: 'Banyak orang mengikuti Yesus karena mereka telah melihat mukjizat penyembuhan-Nya dan mendengar pengajaran-Nya. Menjelang malam, para murid mulai khawatir karena orang banyak berada jauh dari kota dan tidak memiliki makanan.\n\nYesus tidak menyuruh mereka pulang dalam keadaan lapar. Sebaliknya, Ia bertanya apa yang tersedia. Para murid menemukan lima roti dan dua ikan, yang tampaknya sangat sedikit untuk orang sebanyak itu.\n\nYesus mengambil roti dan ikan itu, mengucap syukur, lalu meminta para murid membagikannya. Ketika mereka taat, makanan itu berlipat ganda. Semua orang makan sampai kenyang, dan sesudah itu dikumpulkan dua belas bakul penuh sisa makanan.\n\nKisah ini menunjukkan bahwa Yesus memperhatikan kebutuhan rohani maupun kebutuhan sehari-hari. Ia mengajar dengan kasih, menyediakan dengan kelimpahan, dan mengajak para pengikut-Nya untuk percaya bahkan ketika yang mereka miliki terasa sangat kecil.',
      ),
      testament: Testament.newTestament,
      characterIds: ['char_jesus', 'char_peter'],
      tags: ['miracle', 'compassion', 'provision'],
      scriptureReferences: LocalizedStringList(en: [], id: []),
    ),
    Story(
      id: 'story_david_goliath',
      title: LocalizedText(
        en: 'David and Goliath',
        id: 'Daud dan Goliat',
      ),
      content: LocalizedText(
        en: 'David trusted God and defeated Goliath with courage and faith.',
        id: 'Daud percaya kepada Tuhan dan mengalahkan Goliat dengan keberanian dan iman.',
      ),
      testament: Testament.old,
      characterIds: ['char_david', 'char_goliath'],
      tags: ['faith', 'courage'],
      scriptureReferences: LocalizedStringList(en: [], id: []),
    ),
    Story(
      id: 'story_daniel_lions',
      title: LocalizedText(
        en: 'Daniel in the Lions\' Den',
        id: 'Daniel di Gua Singa',
      ),
      content: LocalizedText(
        en: 'Daniel remained faithful in prayer, and God protected him from the lions.',
        id: 'Daniel tetap setia dalam doa, dan Tuhan melindunginya dari singa-singa.',
      ),
      testament: Testament.old,
      characterIds: ['char_daniel'],
      tags: ['prayer', 'faithfulness'],
      scriptureReferences: LocalizedStringList(en: [], id: []),
    ),
    Story(
      id: 'story_paul_conversion',
      title: LocalizedText(
        en: 'The Conversion of Paul',
        id: 'Pertobatan Paulus',
      ),
      content: LocalizedText(
        en: 'Saul encountered Jesus on the road to Damascus and became Paul.',
        id: 'Saulus berjumpa dengan Yesus di jalan ke Damsyik dan menjadi Paulus.',
      ),
      testament: Testament.newTestament,
      characterIds: ['char_paul'],
      tags: ['grace', 'calling'],
      scriptureReferences: LocalizedStringList(en: [], id: []),
    ),
  ];

  final List<BibleCharacter> _characters = const [
    BibleCharacter(
      id: 'char_david',
      name: LocalizedText(en: 'David', id: 'Daud'),
      testament: Testament.old,
      summary: LocalizedText(
        en: 'A shepherd, warrior, and king known for his trust in God.',
        id: 'Seorang gembala, pejuang, dan raja yang dikenal karena kepercayaannya kepada Tuhan.',
      ),
      strengths: LocalizedStringList(
        en: ['Faith', 'Courage', 'Leadership'],
        id: ['Iman', 'Keberanian', 'Kepemimpinan'],
      ),
      weaknesses: LocalizedStringList(
        en: ['Impulsiveness'],
        id: ['Tergesa-gesa'],
      ),
      relatedCharacterIds: ['char_goliath'],
      identity: LocalizedText(en: '', id: ''),
      lifeSpan: LocalizedText(en: '', id: ''),
    ),
    BibleCharacter(
      id: 'char_goliath',
      name: LocalizedText(en: 'Goliath', id: 'Goliat'),
      testament: Testament.old,
      summary: LocalizedText(
        en: 'A Philistine warrior remembered for pride and intimidation.',
        id: 'Seorang prajurit Filistin yang dikenal karena kesombongan dan ancamannya.',
      ),
      strengths: LocalizedStringList(
        en: ['Physical strength'],
        id: ['Kekuatan fisik'],
      ),
      weaknesses: LocalizedStringList(
        en: ['Pride'],
        id: ['Kesombongan'],
      ),
      relatedCharacterIds: ['char_david'],
      identity: LocalizedText(en: '', id: ''),
      lifeSpan: LocalizedText(en: '', id: ''),
    ),
    BibleCharacter(
      id: 'char_daniel',
      name: LocalizedText(en: 'Daniel', id: 'Daniel'),
      testament: Testament.old,
      summary: LocalizedText(
        en: 'A prophet known for wisdom and unwavering devotion to God.',
        id: 'Seorang nabi yang dikenal karena hikmat dan kesetiaannya kepada Tuhan.',
      ),
      strengths: LocalizedStringList(
        en: ['Wisdom', 'Faithfulness'],
        id: ['Hikmat', 'Kesetiaan'],
      ),
      weaknesses: LocalizedStringList(
        en: ['None highlighted in this sample'],
        id: ['Tidak disorot dalam contoh ini'],
      ),
      relatedCharacterIds: [],
      identity: LocalizedText(en: '', id: ''),
      lifeSpan: LocalizedText(en: '', id: ''),
    ),
    BibleCharacter(
      id: 'char_jesus',
      name: LocalizedText(en: 'Jesus', id: 'Yesus'),
      testament: Testament.newTestament,
      summary: LocalizedText(
        en: 'The central figure of the New Testament, teaching and serving with compassion.',
        id: 'Tokoh utama Perjanjian Baru yang mengajar dan melayani dengan kasih.',
      ),
      strengths: LocalizedStringList(
        en: ['Compassion', 'Wisdom', 'Authority'],
        id: ['Kasih', 'Hikmat', 'Otoritas'],
      ),
      weaknesses: LocalizedStringList(
        en: ['None'],
        id: ['Tidak ada'],
      ),
      relatedCharacterIds: ['char_peter', 'char_paul'],
      identity: LocalizedText(en: '', id: ''),
      lifeSpan: LocalizedText(en: '', id: ''),
    ),
    BibleCharacter(
      id: 'char_peter',
      name: LocalizedText(en: 'Peter', id: 'Petrus'),
      testament: Testament.newTestament,
      summary: LocalizedText(
        en: 'One of Jesus\' closest disciples, bold and often impulsive.',
        id: 'Salah satu murid terdekat Yesus, berani dan sering bertindak cepat.',
      ),
      strengths: LocalizedStringList(
        en: ['Boldness', 'Loyalty'],
        id: ['Keberanian', 'Kesetiaan'],
      ),
      weaknesses: LocalizedStringList(
        en: ['Fear under pressure'],
        id: ['Takut saat tertekan'],
      ),
      relatedCharacterIds: ['char_jesus'],
      identity: LocalizedText(en: '', id: ''),
      lifeSpan: LocalizedText(en: '', id: ''),
    ),
    BibleCharacter(
      id: 'char_paul',
      name: LocalizedText(en: 'Paul', id: 'Paulus'),
      testament: Testament.newTestament,
      summary: LocalizedText(
        en: 'A missionary and writer transformed from persecutor to apostle.',
        id: 'Seorang misionaris dan penulis yang berubah dari penganiaya menjadi rasul.',
      ),
      strengths: LocalizedStringList(
        en: ['Perseverance', 'Teaching'],
        id: ['Ketekunan', 'Pengajaran'],
      ),
      weaknesses: LocalizedStringList(
        en: ['Harshness before conversion'],
        id: ['Kekerasan sebelum bertobat'],
      ),
      relatedCharacterIds: ['char_jesus'],
      identity: LocalizedText(en: '', id: ''),
      lifeSpan: LocalizedText(en: '', id: ''),
    ),
  ];

  @override
  Future<List<Story>> getStories() async => _stories;

  @override
  Future<Story?> getStoryById(String id) async {
    for (final story in _stories) {
      if (story.id == id) {
        return story;
      }
    }
    return null;
  }

  @override
  Future<List<BibleCharacter>> getCharacters() async => _characters;

  @override
  Future<BibleCharacter?> getCharacterById(String id) async {
    for (final character in _characters) {
      if (character.id == id) {
        return character;
      }
    }
    return null;
  }
}

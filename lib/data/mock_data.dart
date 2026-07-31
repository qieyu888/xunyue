import 'dart:math';

import '../models/comment_item.dart';
import '../models/feed_post.dart';
import '../models/moment_post.dart';
import '../models/need_post.dart';
import '../models/user_profile.dart';
import 'app_images.dart';

class MockData {
  static final List<FeedPost> homeFeeds = [
    FeedPost(
      id: 1,
      type: '摄影师',
      title: '夏日胶片感街拍，教你一秒出片！',
      author: '林夏',
      avatar: AppImages.avatars[0],
      image: AppImages.feeds[0],
      imageHeight: 260,
      likes: 42,
      description:
          '这是一段详细的图文描述内容，分享了拍摄的心得、使用的设备以及后期的思路。希望大家喜欢这次的分享！\n\n📷 设备：Sony A7M4 + 50mm F1.2\n🎨 后期：Lightroom\n\n#约拍 #摄影日常 #人像摄影 #我的摄影日记',
    ),
    FeedPost(
      id: 2,
      type: '模特',
      title: '今日份的情绪感特写',
      author: 'Nana',
      avatar: AppImages.avatars[1],
      image: AppImages.feeds[1],
      imageHeight: 200,
      likes: 67,
      description: '捕捉光影里的情绪瞬间，少说话，多感受。',
    ),
    FeedPost(
      id: 3,
      type: '化妆师',
      title: '轻欧美妆容分享，深邃眼影教学',
      author: 'MUA-阿静',
      avatar: AppImages.avatars[2],
      image: AppImages.feeds[2],
      imageHeight: 230,
      likes: 89,
      description: '从打底到眼影层次，一步步拆解轻欧美妆容。',
    ),
    FeedPost(
      id: 4,
      type: '摄影师',
      title: '日系小清新，校园取景地推荐',
      author: '光影捕手',
      avatar: AppImages.avatars[3],
      image: AppImages.feeds[3],
      imageHeight: 280,
      likes: 35,
      description: '几个同城校园取景点，阴天也出片。',
    ),
    FeedPost(
      id: 5,
      type: '模特',
      title: '复古港风，夜景拍摄原片直出',
      author: 'Chloe',
      avatar: AppImages.avatars[4],
      image: AppImages.feeds[4],
      imageHeight: 200,
      likes: 78,
      description: '霓虹与侧光，港风夜拍的小技巧。',
    ),
    FeedPost(
      id: 6,
      type: '化妆师',
      title: '人像拍摄必备：如何打造清透底妆',
      author: '美妆Cici',
      avatar: AppImages.avatars[5],
      image: AppImages.feeds[5],
      imageHeight: 240,
      likes: 51,
      description: '清透底妆不假面，镜头前更自然。',
    ),
    FeedPost(
      id: 7,
      type: '摄影师',
      title: '黄金时刻人像：侧逆光这样打最出片',
      author: '阿杰Photography',
      avatar: AppImages.avatars[6],
      image: AppImages.feeds[6],
      imageHeight: 250,
      likes: 93,
      description: '日落前后 30 分钟，侧逆光让轮廓更干净，记得补一点反光板。',
    ),
    FeedPost(
      id: 8,
      type: '模特',
      title: '咖啡馆窗边光，十分钟拍完一组日常',
      author: 'Sasa_Model',
      avatar: AppImages.avatars[7],
      image: AppImages.feeds[7],
      imageHeight: 210,
      likes: 28,
      description: '靠窗坐、半身构图，手拿杯子就很自然。',
    ),
    FeedPost(
      id: 9,
      type: '化妆师',
      title: '秋冬雾面唇妆搭配低饱和穿搭',
      author: 'MUA喵喵',
      avatar: AppImages.avatars[8],
      image: AppImages.feeds[8],
      imageHeight: 235,
      likes: 64,
      description: '雾面唇少叠高光，整体更高级也更耐拍。',
    ),
    FeedPost(
      id: 10,
      type: '摄影师',
      title: '雨天街拍不慌：慢门与反光地面用法',
      author: '摄影师老王',
      avatar: AppImages.avatars[3],
      image: AppImages.feeds[9],
      imageHeight: 270,
      likes: 81,
      description: '雨天路面反光是免费滤镜，配合慢门能做出电影感。',
    ),
    FeedPost(
      id: 11,
      type: '模特',
      title: '黑白写真姿势合集，冷感拉满',
      author: 'Chloe',
      avatar: AppImages.avatars[4],
      image: AppImages.feeds[10],
      imageHeight: 220,
      likes: 47,
      description: '少看镜头、多看远处，肩线与下巴角度决定冷感。',
    ),
    FeedPost(
      id: 12,
      type: '化妆师',
      title: '新娘跟妆快手流程，不花脸不脱妆',
      author: '美妆Cici',
      avatar: AppImages.avatars[5],
      image: AppImages.feeds[11],
      imageHeight: 245,
      likes: 55,
      description: '定妆喷雾 + 烘焙散粉，一整天活动也不花。',
    ),
    FeedPost(
      id: 13,
      type: '摄影师',
      title: '室内自然光人像：窗帘就是最好的柔光箱',
      author: '光影捕手',
      avatar: AppImages.avatars[9],
      image: AppImages.feeds[12],
      imageHeight: 255,
      likes: 72,
      description: '纱帘透光最柔，主体靠近窗边 45 度最自然。',
    ),
    FeedPost(
      id: 14,
      type: '模特',
      title: '海边风写真：白裙与蓝天这样配',
      author: '甜妹小冉',
      avatar: AppImages.avatars[10],
      image: AppImages.feeds[13],
      imageHeight: 215,
      likes: 39,
      description: '逆光剪影 + 正面补光，海边也能拍出层次。',
    ),
  ];

  static final List<NeedPost> recommendNeeds = [
    NeedPost(
      id: 1,
      author: '阿杰Photography',
      avatar: AppImages.avatars[6],
      type: '找模特',
      tags: const ['风格: 甜美/日系', '地点: 上海', '互勉约拍'],
      content: '周末想去外滩拍一组日系甜美风的胶片，寻找有表现力的女生，服装和妆造我包！',
      images: const [
        'assets/images/need_1a.jpg',
        'assets/images/need_1b.jpg',
      ],
      location: '上海 外滩',
      payMode: '互勉约拍',
    ),
    NeedPost(
      id: 2,
      author: 'Sasa_Model',
      avatar: AppImages.avatars[7],
      type: '找摄影',
      tags: const ['风格: 赛博朋克', '时间: 本周五晚', '付费约拍'],
      content: '想拍一组夜景霓虹灯下的情绪大片，有赛博朋克风后期经验的摄影老师滴滴我，预算充足。',
      images: const ['assets/images/need_2a.jpg'],
      location: '城市夜景街区',
      payMode: '付费约拍',
    ),
    NeedPost(
      id: 3,
      author: '林夏Makeup',
      avatar: AppImages.avatars[1],
      type: '找化妆师',
      tags: const ['需求: 古风妆造', '地点: 杭州西湖'],
      content: '下周要去杭州拍一套汉服，寻找擅长古风妆发的老师，需要跟妆半天。',
      images: const [
        'assets/images/need_3a.jpg',
        'assets/images/need_3b.jpg',
        'assets/images/need_3c.jpg',
      ],
      location: '杭州 西湖',
      payMode: '付费约拍',
    ),
    NeedPost(
      id: 4,
      author: '光影捕手',
      avatar: AppImages.avatars[3],
      type: '找模特',
      tags: const ['风格: 胶片/情绪', '地点: 杭州', '互勉约拍'],
      content: '想拍一组秋日银杏大道的情绪胶片，寻找气质清冷的女生，妆造可自理也可一起商量。',
      images: const [
        'assets/images/feed_4.jpg',
        'assets/images/feed_10.jpg',
      ],
      location: '杭州 银杏大道',
      payMode: '互勉约拍',
      time: '1小时前活跃',
    ),
    NeedPost(
      id: 5,
      author: 'Chloe',
      avatar: AppImages.avatars[4],
      type: '找摄影',
      tags: const ['风格: 日系小清新', '时间: 本周六上午', '付费约拍'],
      content: '第一次约拍，想拍校园日常向写真，希望摄影师有耐心指导姿势，预算可谈。',
      images: const ['assets/images/feed_8.jpg'],
      location: '上海 校园',
      payMode: '付费约拍',
      time: '3小时前活跃',
    ),
    NeedPost(
      id: 6,
      author: '美妆Cici',
      avatar: AppImages.avatars[5],
      type: '找妆造',
      tags: const ['需求: 轻欧美妆', '地点: 深圳'],
      content: '下周有商业棚拍，需要擅长轻欧美妆发的老师跟妆，时间约半天，费用好商量。',
      images: const [
        'assets/images/feed_3.jpg',
        'assets/images/feed_6.jpg',
      ],
      location: '深圳 摄影棚',
      payMode: '付费约拍',
      time: '5小时前活跃',
    ),
    NeedPost(
      id: 7,
      author: '摄影师阿飞',
      avatar: AppImages.avatars[9],
      type: '找模特',
      tags: const ['风格: 港风夜景', '地点: 广州', '收费约拍'],
      content: '计划在上下九夜拍港风大片，提供服装参考与后期精修，寻找有经验的女模特合作。',
      images: const [
        'assets/images/feed_5.jpg',
        'assets/images/feed_11.jpg',
        'assets/images/feed_14.jpg',
      ],
      location: '广州 上下九',
      payMode: '收费约拍',
      time: '昨天活跃',
    ),
    NeedPost(
      id: 8,
      author: '橘子汽水',
      avatar: AppImages.avatars[10],
      type: '找摄影',
      tags: const ['风格: 治愈系', '地点: 成都植物园', '互勉约拍'],
      content: '想在植物园拍一组绿色治愈写真，穿浅色裙子，希望摄影老师擅长自然光人像。',
      images: const ['assets/images/feed_13.jpg'],
      location: '成都 植物园',
      payMode: '互勉约拍',
      time: '昨天活跃',
    ),
  ];

  static final List<MomentPost> moments = [
    MomentPost(
      id: 1,
      author: '摄影师老王',
      avatar: AppImages.avatars[3],
      time: '2小时前',
      category: '后期教程',
      title: '如何调出极简高级的“冷白皮”色调？',
      content:
          '今天教大家一个 LR 后期思路，主要针对室外阴天拍摄的人像。重点是降黄色饱和度，提升蓝色明度，高光加一点青色...',
      images: const ['assets/images/moment_1.jpg'],
      likes: 48,
      comments: 3,
    ),
    MomentPost(
      id: 2,
      author: '模特小青',
      avatar: AppImages.avatars[4],
      time: '5小时前',
      category: '姿势经验',
      title: '面对镜头僵硬？3个万能 Pose 拯救你',
      content:
          '很多新手妹妹第一次约拍都会手足无措，记住这三个口诀：1. 找个东西靠着 2. 手里拿点道具（花、咖啡） 3. 别看镜头看远方！',
      images: const [
        'assets/images/moment_2a.jpg',
        'assets/images/moment_2b.jpg',
        'assets/images/moment_2c.jpg',
      ],
      likes: 92,
      comments: 5,
    ),
    MomentPost(
      id: 3,
      author: 'MUA喵喵',
      avatar: AppImages.avatars[5],
      time: '昨天 14:30',
      category: '妆容细节',
      title: '漫展出 COS，这些定妆好物你必须知道',
      content:
          '漫展一呆就是一天，出汗出油太容易脱妆了。今天分享几款我压箱底的持妆喷雾和烘焙散粉技巧，保证你的底妆焊在脸上！纯文字干货分享，无广！',
      images: const [],
      likes: 67,
      comments: 2,
    ),
    MomentPost(
      id: 4,
      author: '橘子汽水',
      avatar: AppImages.avatars[1],
      time: '昨天 16:20',
      category: '打卡推荐',
      title: '周末去植物园，感受治愈系原野绿',
      content:
          '给大家推荐一个同城宝藏植物园！温室里的仙人掌和热带植物超级适合当背景。建议穿浅色或者白色的衣服，怎么拍都好看！',
      images: const [
        'assets/images/moment_4a.jpg',
        'assets/images/moment_4b.jpg',
      ],
      likes: 35,
      comments: 4,
    ),
    MomentPost(
      id: 5,
      author: '摄影师阿飞',
      avatar: AppImages.avatars[6],
      time: '前天 09:15',
      category: '避雷指南',
      title: '新手小白第一次约拍，这几点一定要注意！',
      content:
          '1. 确认摄影师的作品是否本人原创。2. 约拍地点尽量选择光天化日的公共场所，如公园、商场、咖啡厅。3. 最好有朋友陪伴前往。保护好自己最重要哦！',
      images: const [],
      likes: 88,
      comments: 1,
    ),
    MomentPost(
      id: 6,
      author: '甜妹小冉',
      avatar: AppImages.avatars[7],
      time: '3天前',
      category: '道具推荐',
      title: '十几块钱的透明伞，雨天出片神器',
      content:
          '阴雨天光线不好不要怕，买一把便利店最便宜的透明伞。晚上利用街边的路灯或者商店橱窗的反光，分分钟拍出日剧女主角的感觉！',
      images: const ['assets/images/moment_6.jpg'],
      likes: 74,
      comments: 5,
    ),
    MomentPost(
      id: 7,
      author: '林夏Makeup',
      avatar: AppImages.avatars[2],
      time: '3天前',
      category: '妆容细节',
      title: '元气少女感！10分钟早八伪素颜妆',
      content:
          '早上起不来但又想美美出门？教你个极简公式：防晒 + 局部遮瑕 + 清透蜜粉 + 橘粉色腮红当眼影扫过。重点是野生眉，不用画太精细，更有呼吸感。',
      images: const [
        'assets/images/moment_7a.jpg',
        'assets/images/moment_7b.jpg',
        'assets/images/moment_7c.jpg',
      ],
      likes: 59,
      comments: 3,
    ),
    MomentPost(
      id: 8,
      author: '光影捕手',
      avatar: AppImages.avatars[3],
      time: '4天前',
      category: '滤镜分享',
      title: '手机也能调出的胶片感，VSCO 参数分享',
      content:
          '想要浓郁的复古色调其实很简单。滤镜选 V3，曝光 -1，对比度 -0.5，褪色 +2，颗粒 +3。高光稍微加一点点橘色，阴影加蓝色，这就完成了！',
      images: const [
        'assets/images/moment_8a.jpg',
        'assets/images/moment_8b.jpg',
      ],
      likes: 41,
      comments: 2,
    ),
    MomentPost(
      id: 9,
      author: '看展达人',
      avatar: AppImages.avatars[8],
      time: '5天前',
      category: '经验分享',
      title: '美术馆拍照，怎么才能不路人？',
      content:
          '去美术馆看展，背景往往很纯粹。这个时候动作要大！利用展馆的几何线条作为引导线。另外，记得关闭闪光灯哦，不要影响他人观展。',
      images: const ['assets/images/moment_9.jpg'],
      likes: 83,
      comments: 4,
    ),
    MomentPost(
      id: 10,
      author: 'Nana_酱',
      avatar: AppImages.avatarMe,
      time: '刚刚',
      category: '姿势经验',
      title: '今日份练姿记录，窗边光真的绝',
      content: '下午在家靠窗拍了几张，侧逆光把发丝勾得很干净。分享给同样喜欢情绪片的姐妹～',
      images: const ['assets/images/work_2.jpg', 'assets/images/work_5.jpg'],
      likes: 66,
      comments: 4,
    ),
  ];

  /// 评论素材池；各帖按 threadKey 确定性抽取，避免详情页评论雷同。
  static final List<CommentItem> comments = [
    CommentItem(id: 1, author: '清风徐来', avatar: AppImages.avatars[8], content: '请问用的什么镜头？虚化也太干净了', time: '1小时前', likes: 12),
    CommentItem(id: 2, author: '七七_77', avatar: AppImages.avatars[9], content: '同城求约拍！接不接新手小白呀', time: '3小时前', likes: 5),
    CommentItem(id: 3, author: '阿杰Photography', avatar: AppImages.avatars[6], content: '这个色调绝了，马上去试着调一下', time: '5小时前', likes: 8),
    CommentItem(id: 4, author: '橘子汽水', avatar: AppImages.avatars[1], content: '窗边光真的很加分，学到了', time: '昨天', likes: 3),
    CommentItem(id: 5, author: '光影捕手', avatar: AppImages.avatars[3], content: '构图和光比都很好，收藏了', time: '昨天', likes: 7),
    CommentItem(id: 6, author: 'MUA喵喵', avatar: AppImages.avatars[5], content: '妆面和服装搭配好和谐，求妆品清单', time: '2小时前', likes: 9),
    CommentItem(id: 7, author: '甜妹小冉', avatar: AppImages.avatars[7], content: '这组氛围感拉满，想同款姿势', time: '4小时前', likes: 4),
    CommentItem(id: 8, author: '看展达人', avatar: AppImages.avatars[8], content: '取景点也太会选了，记下了', time: '6小时前', likes: 6),
    CommentItem(id: 9, author: '摄影师阿飞', avatar: AppImages.avatars[9], content: '侧逆光处理得很自然，干货！', time: '昨天', likes: 11),
    CommentItem(id: 10, author: 'Chloe', avatar: AppImages.avatars[4], content: '表情好松弛，完全没有僵硬感', time: '昨天', likes: 2),
    CommentItem(id: 11, author: '美妆Cici', avatar: AppImages.avatars[5], content: '底妆在镜头下居然一点不假面', time: '刚刚', likes: 1),
    CommentItem(id: 12, author: '林夏Makeup', avatar: AppImages.avatars[2], content: '眼神光好漂亮，请问怎么打的？', time: '1小时前', likes: 14),
    CommentItem(id: 13, author: 'Sasa_Model', avatar: AppImages.avatars[7], content: '这套动作我下次也试试', time: '3小时前', likes: 3),
    CommentItem(id: 14, author: '摄影师老王', avatar: AppImages.avatars[3], content: '后期克制得很舒服，不油腻', time: '5小时前', likes: 10),
    CommentItem(id: 15, author: 'MUA-阿静', avatar: AppImages.avatars[2], content: '眼影层次感好强，截图学习', time: '昨天', likes: 5),
    CommentItem(id: 16, author: '阿杰Photography', avatar: AppImages.avatars[6], content: '阴天拍出了电影感，厉害', time: '2天前', likes: 7),
    CommentItem(id: 17, author: '清风徐来', avatar: AppImages.avatars[8], content: '请问原片直出还是有调色？', time: '8小时前', likes: 4),
    CommentItem(id: 18, author: '七七_77', avatar: AppImages.avatars[9], content: '背景虚化好丝滑，焦段多少呀', time: '昨天', likes: 6),
    CommentItem(id: 19, author: '橘子汽水', avatar: AppImages.avatars[1], content: '白裙配蓝天太夏天了，想去同款', time: '3天前', likes: 8),
    CommentItem(id: 20, author: '光影捕手', avatar: AppImages.avatars[3], content: '引导线用得巧妙，空间感很强', time: '4小时前', likes: 9),
    CommentItem(id: 21, author: '甜妹小冉', avatar: AppImages.avatars[7], content: '发丝光好绝，求拍摄时段', time: '1天前', likes: 3),
    CommentItem(id: 22, author: '看展达人', avatar: AppImages.avatars[8], content: '冷白皮调色思路清晰，感谢分享', time: '2小时前', likes: 12),
    CommentItem(id: 23, author: '摄影师阿飞', avatar: AppImages.avatars[9], content: '雨天反光拍得太有意境了', time: '昨天', likes: 15),
    CommentItem(id: 24, author: 'Chloe', avatar: AppImages.avatars[4], content: '黑白质感好高级，肩线也好看', time: '6小时前', likes: 4),
    CommentItem(id: 25, author: '美妆Cici', avatar: AppImages.avatars[5], content: '定妆技巧收藏了，下次漫展用', time: '刚刚', likes: 2),
    CommentItem(id: 26, author: '林夏', avatar: AppImages.avatars[0], content: '胶片感拉满，参数方便分享吗？', time: '3小时前', likes: 11),
    CommentItem(id: 27, author: 'Nana', avatar: AppImages.avatars[1], content: '情绪到位，少说话多感受说得对', time: '5小时前', likes: 5),
    CommentItem(id: 28, author: 'MUA喵喵', avatar: AppImages.avatars[5], content: '雾面唇妆真的耐拍，记下了', time: '昨天', likes: 6),
    CommentItem(id: 29, author: 'Sasa_Model', avatar: AppImages.avatars[7], content: '咖啡馆窗边光拍法很实用', time: '2天前', likes: 3),
    CommentItem(id: 30, author: '阿杰Photography', avatar: AppImages.avatars[6], content: '黄金时刻这篇写得太细了', time: '1小时前', likes: 13),
    CommentItem(id: 31, author: '清风徐来', avatar: AppImages.avatars[8], content: '透明伞这个道具太妙了', time: '4小时前', likes: 7),
    CommentItem(id: 32, author: '七七_77', avatar: AppImages.avatars[9], content: '第一次约拍避雷清单收藏！', time: '昨天', likes: 18),
    CommentItem(id: 33, author: '橘子汽水', avatar: AppImages.avatars[1], content: '植物园取景确实治愈，下周就去', time: '3小时前', likes: 4),
    CommentItem(id: 34, author: '光影捕手', avatar: AppImages.avatars[3], content: 'VSCO 参数试了，胶片感出来了', time: '5小时前', likes: 9),
    CommentItem(id: 35, author: '甜妹小冉', avatar: AppImages.avatars[7], content: '伪素颜妆超适合早八，谢谢', time: '昨天', likes: 5),
    CommentItem(id: 36, author: '看展达人', avatar: AppImages.avatars[8], content: '美术馆拍照姿势学到了，不路人', time: '2小时前', likes: 8),
    CommentItem(id: 37, author: '摄影师阿飞', avatar: AppImages.avatars[9], content: '港风夜景这块光线用得很稳', time: '6小时前', likes: 6),
    CommentItem(id: 38, author: 'Chloe', avatar: AppImages.avatars[4], content: '校园小清新好有生活感', time: '1天前', likes: 2),
    CommentItem(id: 39, author: '美妆Cici', avatar: AppImages.avatars[5], content: '新娘跟妆流程很清晰，实用', time: '昨天', likes: 10),
    CommentItem(id: 40, author: '林夏Makeup', avatar: AppImages.avatars[2], content: '古风妆发求推荐同城老师', time: '4小时前', likes: 3),
    CommentItem(id: 41, author: 'Sasa_Model', avatar: AppImages.avatars[7], content: '赛博朋克这组霓虹好出片', time: '刚刚', likes: 7),
    CommentItem(id: 42, author: '阿杰Photography', avatar: AppImages.avatars[6], content: '互勉约拍求同城有缘人', time: '2小时前', likes: 4),
    CommentItem(id: 43, author: '清风徐来', avatar: AppImages.avatars[8], content: '银杏大道秋天一定很美', time: '昨天', likes: 5),
    CommentItem(id: 44, author: '七七_77', avatar: AppImages.avatars[9], content: '预算写清楚了，沟通成本低很多', time: '3小时前', likes: 6),
    CommentItem(id: 45, author: '橘子汽水', avatar: AppImages.avatars[1], content: '服装妆造包了也太友好了吧', time: '5小时前', likes: 8),
    CommentItem(id: 46, author: '光影捕手', avatar: AppImages.avatars[3], content: '室内纱帘柔光这篇直接抄作业', time: '1天前', likes: 11),
    CommentItem(id: 47, author: '甜妹小冉', avatar: AppImages.avatars[7], content: '手拿咖啡这个动作真自然', time: '6小时前', likes: 2),
    CommentItem(id: 48, author: '看展达人', avatar: AppImages.avatars[8], content: '慢门雨景拍法收藏，下次试试', time: '昨天', likes: 9),
    CommentItem(id: 49, author: '摄影师阿飞', avatar: AppImages.avatars[9], content: '反光板补光细节讲得很到位', time: '2小时前', likes: 7),
    CommentItem(id: 50, author: 'Chloe', avatar: AppImages.avatars[4], content: '冷感黑白这组肩线绝了', time: '刚刚', likes: 4),
  ];

  /// 按 threadKey 抽取互不雷同的默认评论（同一帖内不重复）。
  static List<CommentItem> seededCommentsFor(String threadKey, int count) {
    final n = count.clamp(0, comments.length);
    if (n == 0) return const [];

    final indices = List<int>.generate(comments.length, (i) => i);
    indices.shuffle(Random(threadKey.hashCode));

    return List<CommentItem>.generate(n, (i) {
      final source = comments[indices[i]];
      return source.copyWith(id: indices[i] + 1);
    });
  }

  static final List<FeedPost> profileWorks = [
    FeedPost(
      id: 101,
      type: '模特',
      title: '霓虹夜拍，赛博朋克风',
      author: 'Nana_酱',
      avatar: AppImages.avatarMe,
      image: AppImages.works[0],
      likes: 128,
    ),
    FeedPost(
      id: 102,
      type: '模特',
      title: '街头随拍',
      author: 'Nana_酱',
      avatar: AppImages.avatarMe,
      image: AppImages.works[1],
      likes: 256,
    ),
    FeedPost(
      id: 103,
      type: '模特',
      title: '光影游戏',
      author: 'Nana_酱',
      avatar: AppImages.avatarMe,
      image: AppImages.works[2],
      likes: 342,
    ),
    FeedPost(
      id: 104,
      type: '模特',
      title: '夏日胶片',
      author: 'Nana_酱',
      avatar: AppImages.avatarMe,
      image: AppImages.works[3],
      likes: 512,
    ),
    FeedPost(
      id: 105,
      type: '模特',
      title: '情绪特写',
      author: 'Nana_酱',
      avatar: AppImages.avatarMe,
      image: AppImages.works[4],
      likes: 89,
    ),
  ];

  /// 他人主页资料（按昵称）；未收录作者走 [profileFor]。
  static final Map<String, UserProfile> publicProfiles = {
    '林夏': const UserProfile(
      nickname: '林夏',
      userId: '7201845',
      avatar: 'assets/images/avatar_1.jpg',
      gender: '女',
      birthday: '1998-05-20',
      city: '浙江 杭州',
      role: '摄影师',
      tags: '胶片 街拍 自然光',
      bio: '喜欢用胶片记录夏天。接同城互勉/付费约拍，私信沟通档期。',
      likes: 86,
      following: 128,
      fans: '2.1k',
    ),
    'Nana': const UserProfile(
      nickname: 'Nana',
      userId: '6612034',
      avatar: 'assets/images/avatar_2.jpg',
      gender: '女',
      birthday: '2001-03-08',
      city: '上海',
      role: '独立模特',
      tags: '情绪 日系 特写',
      bio: '情绪向人像为主，不接私房。周末有空可约。',
      likes: 64,
      following: 96,
      fans: '3.4k',
    ),
    'MUA-阿静': const UserProfile(
      nickname: 'MUA-阿静',
      userId: '5109821',
      avatar: 'assets/images/avatar_3.jpg',
      gender: '女',
      birthday: '1997-11-12',
      city: '广东 广州',
      role: '化妆师',
      tags: '新娘妆 舞台妆 修容',
      bio: '专业跟妆五年，擅长新娘与舞台妆。可出妆到棚/外景。',
      likes: 72,
      following: 54,
      fans: '1.8k',
    ),
    '光影捕手': const UserProfile(
      nickname: '光影捕手',
      userId: '8840123',
      avatar: 'assets/images/avatar_4.jpg',
      gender: '男',
      birthday: '1995-09-01',
      city: '北京',
      role: '摄影师',
      tags: '人像 调色 商业',
      bio: '人像与商业摄影，日系/港风都可。设备齐全，欢迎合作。',
      likes: 95,
      following: 210,
      fans: '5.6k',
    ),
    'Chloe': const UserProfile(
      nickname: 'Chloe',
      userId: '3301789',
      avatar: 'assets/images/avatar_5.jpg',
      gender: '女',
      birthday: '2000-01-18',
      city: '四川 成都',
      role: '模特',
      tags: '冷感 黑白 高级感',
      bio: '冷白皮向，擅长黑白与极简构图。互勉友好，付费优先。',
      likes: 58,
      following: 77,
      fans: '1.2k',
    ),
    '美妆Cici': const UserProfile(
      nickname: '美妆Cici',
      userId: '4412098',
      avatar: 'assets/images/avatar_6.jpg',
      gender: '女',
      birthday: '1999-07-22',
      city: '江苏 南京',
      role: '化妆师',
      tags: '伪素颜 通勤妆 定妆',
      bio: '专注镜头友好妆面，漫展/约拍妆可接。产品清单可私信。',
      likes: 41,
      following: 132,
      fans: '980',
    ),
    '阿杰Photography': const UserProfile(
      nickname: '阿杰Photography',
      userId: '9023411',
      avatar: 'assets/images/avatar_7.jpg',
      gender: '男',
      birthday: '1994-04-15',
      city: '浙江 杭州',
      role: '摄影师',
      tags: '外景 互勉 人像',
      bio: '同城约拍欢迎，新手友好。擅长黄金时刻与阴天氛围感。',
      likes: 77,
      following: 188,
      fans: '4.2k',
    ),
    'Sasa_Model': const UserProfile(
      nickname: 'Sasa_Model',
      userId: '2187340',
      avatar: 'assets/images/avatar_8.jpg',
      gender: '女',
      birthday: '2002-08-30',
      city: '广东 深圳',
      role: '模特',
      tags: '甜妹 校园 清新',
      bio: '学生党模特，周末可约。喜欢小清新与校园风。',
      likes: 39,
      following: 65,
      fans: '760',
    ),
    'MUA喵喵': const UserProfile(
      nickname: 'MUA喵喵',
      userId: '6754092',
      avatar: 'assets/images/avatar_6.jpg',
      gender: '女',
      birthday: '1998-12-03',
      city: '福建 厦门',
      role: '化妆师',
      tags: '古风 妆发 影视妆',
      bio: '古风妆发与影视妆方向，可携带全套妆造到片场。',
      likes: 53,
      following: 91,
      fans: '1.5k',
    ),
    '摄影师老王': const UserProfile(
      nickname: '摄影师老王',
      userId: '1002847',
      avatar: 'assets/images/avatar_4.jpg',
      gender: '男',
      birthday: '1990-06-06',
      city: '陕西 西安',
      role: '摄影师',
      tags: '干货 教学 外拍',
      bio: '分享实用拍摄干货，也接约拍。后期克制、自然出片。',
      likes: 88,
      following: 43,
      fans: '6.8k',
    ),
    '模特小青': const UserProfile(
      nickname: '模特小青',
      userId: '5567812',
      avatar: 'assets/images/avatar_5.jpg',
      gender: '女',
      birthday: '2001-10-25',
      city: '浙江 杭州',
      role: '模特',
      tags: 'Pose 情绪 海边',
      bio: '面对镜头也不怕～分享万能 Pose，接同城约拍。',
      likes: 67,
      following: 112,
      fans: '2.9k',
    ),
    '橘子汽水': const UserProfile(
      nickname: '橘子汽水',
      userId: '3348901',
      avatar: 'assets/images/avatar_2.jpg',
      gender: '女',
      birthday: '2003-02-14',
      city: '湖南 长沙',
      role: '模特',
      tags: '夏日 清新 道具',
      bio: '爱夏天和透明伞！互勉约拍多多益善～',
      likes: 28,
      following: 156,
      fans: '540',
    ),
    '摄影师阿飞': const UserProfile(
      nickname: '摄影师阿飞',
      userId: '7781203',
      avatar: 'assets/images/avatar_10.jpg',
      gender: '男',
      birthday: '1996-08-19',
      city: '重庆',
      role: '摄影师',
      tags: '夜景 港风 反光板',
      bio: '夜景与港风爱好者，补光细节控。可接商拍/约拍。',
      likes: 61,
      following: 99,
      fans: '3.1k',
    ),
    '甜妹小冉': const UserProfile(
      nickname: '甜妹小冉',
      userId: '4456710',
      avatar: 'assets/images/avatar_8.jpg',
      gender: '女',
      birthday: '2002-05-05',
      city: '云南 昆明',
      role: '模特',
      tags: '甜妹 伪素颜 早八',
      bio: '伪素颜爱好者，喜欢轻松自然的约拍氛围。',
      likes: 35,
      following: 80,
      fans: '890',
    ),
    '林夏Makeup': const UserProfile(
      nickname: '林夏Makeup',
      userId: '7201999',
      avatar: 'assets/images/avatar_3.jpg',
      gender: '女',
      birthday: '1998-05-20',
      city: '浙江 杭州',
      role: '化妆师',
      tags: '古风 新娘 妆发',
      bio: '林夏妆造工作室，古风与新娘妆方向。同城可上门。',
      likes: 49,
      following: 70,
      fans: '1.1k',
    ),
    '看展达人': const UserProfile(
      nickname: '看展达人',
      userId: '8890345',
      avatar: 'assets/images/avatar_9.jpg',
      gender: '女',
      birthday: '1997-03-28',
      city: '上海',
      role: '摄影师',
      tags: '美术馆 姿势 构图',
      bio: '爱逛展也爱拍展，分享不路人的拍照姿势。',
      likes: 44,
      following: 203,
      fans: '2.4k',
    ),
  };

  /// 解析他人公开资料；有内容时可推断身份与头像。
  static UserProfile profileFor(String author, {String? avatar}) {
    final known = publicProfiles[author];
    if (known != null) {
      if (avatar != null && avatar.isNotEmpty && avatar != known.avatar) {
        return known.copyWith(avatar: avatar);
      }
      return known;
    }

    String? inferredAvatar = avatar;
    String role = '约拍达人';
    for (final post in homeFeeds) {
      if (post.author == author) {
        inferredAvatar ??= post.avatar;
        role = post.type;
        break;
      }
    }
    if (inferredAvatar == null || role == '约拍达人') {
      for (final need in recommendNeeds) {
        if (need.author == author) {
          inferredAvatar ??= need.avatar;
          if (role == '约拍达人') role = need.type;
          break;
        }
      }
    }
    if (inferredAvatar == null) {
      for (final moment in moments) {
        if (moment.author == author) {
          inferredAvatar ??= moment.avatar;
          break;
        }
      }
    }
    if (inferredAvatar == null) {
      for (final comment in comments) {
        if (comment.author == author) {
          inferredAvatar = comment.avatar;
          break;
        }
      }
    }

    final hash = author.hashCode.abs();
    final cities = ['浙江 杭州', '上海', '北京', '广东 广州', '四川 成都', '江苏 南京'];
    return UserProfile(
      nickname: author,
      userId: '${8800000 + hash % 100000}',
      avatar: inferredAvatar ?? AppImages.avatars[hash % AppImages.avatars.length],
      gender: hash.isEven ? '女' : '男',
      birthday: '2000-01-01',
      city: cities[hash % cities.length],
      role: role,
      tags: '约拍 互勉',
      bio: '这个人很懒，还没有填写简介。',
      likes: 10 + hash % 90,
      following: 20 + hash % 180,
      fans: '${100 + hash % 900}',
    );
  }

  static final List<FeedPost> profileFavorites = [
    FeedPost(
      id: 201,
      type: '化妆师',
      title: '日常通勤妆容分享',
      author: 'MUA-阿静',
      avatar: AppImages.avatars[2],
      image: AppImages.favorites[0],
      likes: 2301,
    ),
    FeedPost(
      id: 202,
      type: '摄影师',
      title: '日系调色思路',
      author: '光影捕手',
      avatar: AppImages.avatars[3],
      image: AppImages.favorites[1],
      likes: 642,
    ),
    FeedPost(
      id: 203,
      type: '模特',
      title: '拍照姿势大全',
      author: 'Chloe',
      avatar: AppImages.avatars[4],
      image: AppImages.favorites[2],
      likes: 1890,
    ),
    FeedPost(
      id: 204,
      type: '摄影师',
      title: '胶片感街拍技巧',
      author: '林夏',
      avatar: AppImages.avatars[0],
      image: AppImages.favorites[3],
      likes: 1240,
    ),
  ];
}

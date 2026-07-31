# 个人主页互动统计设计

## 目标

个人主页的“获赞与收藏”“关注”“粉丝”均可点击，外部数字与详情内容始终使用同一份本机数据。

## 数据流

- 获赞与收藏：`likedIds.length + collectedIds.length`，详情按“点赞”和“收藏”分页展示。
- 关注：`followedAuthors.length`，详情展示本机已关注用户，并支持取消关注。
- 粉丝：当前没有本机粉丝数据，固定为 `0`，详情展示空状态。

收藏列表复用 `AppStore.favorites`。点赞列表由 `likedIds` 解析为作品或动态。关注列表直接读取
`followedAuthors`，用户资料通过现有 `MockData.profileFor` 解析。所有页面在返回个人主页后触发刷新，
确保列表变化立即反映到统计数字。

## 验证

运行 `dart format`、`flutter analyze` 和测试；在 iPhone Simulator 中验证三个统计项可点击、列表数量与
外部数字一致，以及取消关注后数字同步减少。

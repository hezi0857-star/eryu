# 在小云（腾讯云轻量 · Ubuntu + Docker）上部署 eryu

数据目录放在宿主机 `~/eryu-data`，映射到容器 `/app/server/data`。

```bash
git clone https://github.com/hezi0857-star/eryu.git ~/eryu && cd ~/eryu
echo "ERYU_SECRET=<共享令牌>" > .env && chmod 600 .env   # 不进 git
mkdir -p ~/eryu-data/music_cache
docker build -t eryu .
docker run -d --name eryu --restart unless-stopped --env-file .env \
  -p 127.0.0.1:19090:9090 -v ~/eryu-data:/app/server/data eryu
```

外网走 Cloudflare Tunnel：`eryu.amistveil.com` → `http://localhost:19090`。

## 数据
- `music_data.json` 歌单/最近/主页资料，`music_memory.json` 每首歌的听歌记忆，`music_playlist.json` 旧版歌单
- `.netease_cred` 网易云 Cookie（`MUSIC_U=...`），每次请求重新读，换了不用重启；可在小家音乐页里换（POST /music/cookie）
- `music_cache/` 歌曲缓存，丢了会自动重新下载
- 歌单与听歌记忆每天自动备份到私有仓库 `eryu-data`

## 2026-10-30 改动
- 同一首歌并发请求时加锁排队下载，临时文件按线程区分，修“首次播放常失败、刷新才好”
- 服务端下载失败自动重试一次
- `GET /music/cookie/status`、`POST /music/cookie`：查/换网易云 Cookie
- Cookie 优先读 `data/.netease_cred`

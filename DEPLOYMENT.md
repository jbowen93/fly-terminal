# Deployment Guide for Retro Terminal Chat

## Prerequisites
- Fly CLI installed on your local machine
- Fly.io account (free tier available)
- Your code repository cloned locally

## Fly.io Deployment Steps

### 1. Install Fly CLI (if not already installed)
```bash
# macOS
brew install flyctl

# Linux
curl -L https://fly.io/install.sh | sh

# Windows
powershell -Command "iwr https://fly.io/install.ps1 -useb | iex"
```

### 2. Login to Fly.io
```bash
fly auth login
```

### 3. Set Required Secrets
```bash
# Generate and set the secret key base
fly secrets set SECRET_KEY_BASE="QqSFPPc/frZtxg5uTQd731WTJZlMKS1fw/aeWkcDDA9XMJaZkMpeumSLVqt4rARy"

# The DATABASE_PATH is already configured in fly.toml
```

### 4. Create the App (one-time setup)
```bash
fly apps create retro-terminal-chat
```

### 5. Create Persistent Volume for SQLite Database
```bash
fly volumes create chat_app_data --region iad --size 1
```

### 6. Deploy the Application
```bash
fly deploy
```

### 7. Check Application Status
```bash
fly status
fly logs
```

## Configuration Details

- **App Name**: retro-terminal-chat
- **Region**: iad (US East)
- **Database**: SQLite with persistent volume
- **Memory**: 1GB
- **URL**: https://retro-terminal-chat.fly.dev

## Production Environment Variables

The following are configured in `fly.toml`:
- `PHX_HOST`: retro-terminal-chat.fly.dev
- `PORT`: 8080
- `PHX_SERVER`: true
- `DATABASE_PATH`: /app/data/chat_app.db

## Troubleshooting

### Database Issues
If you encounter database issues, you can run migrations manually:
```bash
fly ssh console
/app/bin/migrate
```

### Checking Logs
```bash
fly logs --follow
```

### SSH into the Application
```bash
fly ssh console
```

Your retro terminal chat app will be available at: https://retro-terminal-chat.fly.dev


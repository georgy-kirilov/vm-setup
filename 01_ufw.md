# Uncomplicated Firewall

### 1. **Install UFW**:
```bash
sudo apt update
```
```bash
sudo apt install ufw
```

### 2. **Allow SSH Through Firewall**:
```bash
sudo ufw allow OpenSSH
```

### 3. **Enable UFW**:
```bash
echo 'y' | sudo ufw enable
```

### 4. **Allow Docker Through Firewall**:
```bash
sudo ufw allow 2375,2376/tcp
```

### 5. **Reload Firewall**:
```bash
sudo ufw reload
```

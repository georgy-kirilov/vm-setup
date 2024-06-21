# Create a DNS record for your domain and the VM's IP address

### 1. Run a dummy NGINX instance on port 80:

```bash
docker run -it --rm -d -p 80:80 --name web nginx
```

### 2. Add DNS settings in your domain provider web dashboard.

### 3. Once you can access the NGINX default page through your domain address in your browser, stop the nginx instance.

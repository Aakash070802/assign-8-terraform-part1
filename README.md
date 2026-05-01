# 🚀 Terraform Deployment: Flask + Express on Single EC2

## 📌 Overview

This project provisions an AWS EC2 instance using Terraform and deploys:

- **Flask Backend** → Handles API requests
- **Express Frontend** → Handles UI + form submission

Both services run on the same machine but on different ports.

**Live URLs:**

- Frontend → [http://3.110.30.52:3000/](http://3.110.30.52:3000/)
- Backend → [http://3.110.30.52:5000/](http://3.110.30.52:5000/)

---

## 🏗️ Architecture

```
User (Browser)
      │
      ▼
Express Frontend (Port 3000)
      │
      ▼
Flask Backend (Port 5000)
      │
      ▼
Response → Frontend → User
```

### What’s actually happening

- User submits form → Express receives request
- Express forwards request → Flask (`/submit`)
- Flask processes → returns JSON
- Express renders success page

---

## 📁 Project Structure

```
├── backend
│   ├── app.py
│   ├── requirements.txt
│   └── Dockerfile
│
├── frontend
│   ├── app.js
│   ├── package.json
│   ├── views/
│   ├── public/
│   └── Dockerfile
│
├── main.tf
├── variables.tf
├── outputs.tf
```

---

## ⚙️ Infrastructure (Terraform)

### What Terraform Creates

- EC2 instance (Ubuntu)
- Security Group with:
  - Port 22 → SSH
  - Port 3000 → Frontend
  - Port 5000 → Backend

### Bootstrapping (user_data)

On instance launch:

- Installs Python + Flask
- Installs Node.js + npm
- Clones project repo
- Starts:
  - Flask → port 5000
  - Express → port 3000

---

## 🔗 Service Communication

Frontend uses `.env`:

```
BACKEND_URL=http://3.110.30.52:5000/submit
```

Flow inside `app.js`:

```js
const response = await fetch(BACKEND_URL, {
  method: "POST",
  body: new URLSearchParams(req.body),
});
```

---

## 🧠 Why This Design?

Let’s not pretend this is production-grade. It’s intentional.

### 1. Single EC2 Instance

- Keeps infra simple
- Faster to deploy
- Good for learning infra + app integration

### 2. Separate Backend & Frontend

- Clear separation of concerns
- Mimics real-world architecture
- Enables independent scaling later

### 3. Direct HTTP Communication

- No API Gateway / Load Balancer
- Reduces complexity for this stage

### 4. user_data Bootstrapping

- Fully automated provisioning
- No manual setup after `terraform apply`

---

## ⚖️ Trade-offs

Here’s where you need to be honest — most people mess this up.

### ❌ Weaknesses

- **Single point of failure**
  If EC2 dies → everything is down

- **No process manager**
  Using `nohup` is fragile
  (No restart, no monitoring)

- **No reverse proxy (Nginx)**
  Exposes ports directly → not ideal

- **Hardcoded backend URL**
  Breaks if IP changes

- **No HTTPS**
  Completely insecure in real-world terms

---

### ✅ Why it’s still valid

Because the goal here is:

- Learn Terraform
- Understand infra + app linkage
- Validate networking & communication

Not to build a production SaaS.

---

## 🚨 What I’d Improve Next (Real Engineering Thinking)

If you say this in interview, you win instantly:

1. Replace `nohup` → **PM2 / systemd**
2. Add **Nginx reverse proxy**
3. Move backend URL → **dynamic config / DNS**
4. Add **Elastic IP**
5. Use **Docker Compose or Kubernetes**
6. Add **Load Balancer (ALB)**
7. Enable **HTTPS (Let’s Encrypt)**

---

## 🎯 Final Result

- Terraform successfully provisions infrastructure
- Flask backend and Express frontend run together
- End-to-end form submission works
- System is accessible via public IP

---

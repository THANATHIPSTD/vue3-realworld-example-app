# ใช้ Node.js เพื่อ build แอป
FROM node:18-alpine AS build

# กำหนด working directory
WORKDIR /app

# คัดลอกไฟล์ที่จำเป็น
COPY package.json pnpm-lock.yaml ./

# ติดตั้ง dependencies
RUN npm install -g pnpm && pnpm install

# คัดลอกโค้ดทั้งหมด
COPY . .

# Build แอปด้วย Vite
RUN pnpm run build

# ---- Serve with Nginx ----
FROM nginx:alpine AS production

# คัดลอกไฟล์ build ไปยัง Nginx
COPY --from=build /app/dist /usr/share/nginx/html

# คัดลอกไฟล์คอนฟิก Nginx (ถ้ามี)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# เปิดพอร์ต 80
EXPOSE 80

# เริ่มต้น nginx
CMD ["nginx", "-g", "daemon off;"]

# Sử dụng image Node.js phiên bản LTS chạy trên nền Alpine Linux (nhẹ và tối ưu)
FROM node:lts-alpine

# Đặt biến môi trường NODE_ENV để chỉ chạy ứng dụng ở chế độ production
ENV NODE_ENV=production

# Thiết lập thư mục làm việc bên trong container
WORKDIR /usr/src/app

# Sao chép các file quản lý dependencies (package.json, package-lock.json hoặc npm-shrinkwrap.json nếu có) vào container
COPY ["package.json", "package-lock.json*", "npm-shrinkwrap.json*", "./"]

# Cài đặt các dependencies cần thiết cho chế độ production và di chuyển thư mục node_modules ra ngoài thư mục làm việc
RUN npm install --production --silent && mv node_modules ../

# Sao chép toàn bộ mã nguồn của ứng dụng vào container
COPY . .

# Mở cổng 5173 để container có thể lắng nghe (thường dùng với Vite hoặc công cụ tương tự)
EXPOSE 5173

# Thay đổi quyền sở hữu thư mục làm việc và nội dung cho người dùng 'node'
RUN chown -R node /usr/src/app

# Thiết lập người dùng mặc định là 'node' (tăng cường bảo mật, tránh chạy với quyền root)
USER node

# Lệnh khởi chạy ứng dụng khi container bắt đầu
CMD ["npm", "start"]
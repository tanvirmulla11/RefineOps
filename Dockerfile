# ✅ Use lightweight Nginx image
FROM nginx:alpine

# ✅ Set working directory
WORKDIR /usr/share/nginx/html

# ✅ Remove default Nginx page
RUN rm -rf ./*

# ✅ Copy your silver billing web app
COPY index.html index.html

# ✅ Expose port 80 for public access
EXPOSE 80

# ✅ Start Nginx
CMD ["nginx", "-g", "daemon off;"]

FROM nginx:alpine

COPY index.html /usr/share/nginx/html/
COPY jonathan-gray-cv.pdf /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

# Using node image
FROM node:18-alpine

# Set working Directory
WORKDIR /app

# Copy files
COPY package*.json ./
RUN npm install

COPY . .

# Expose port
EXPOSE 3000

# Run app
CMD [ "npm", "start" ]
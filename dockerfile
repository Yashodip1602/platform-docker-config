FROM node:18-alpine

WORKDIR /app

# all dependencies 
COPY package*.json ./
RUN npm ci

# Source code
COPY . .

# Build step
RUN npm run build

# Non-root user
RUN addgroup -g 1001 -S nodejs && adduser -S nodeuser -u 1001
RUN chown -R nodeuser:nodejs /app
USER nodeuser

EXPOSE 3000

CMD ["npm", "start"]
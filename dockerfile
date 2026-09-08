# ---------- Stage 1: Build ----------
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

RUN npm run build

# ---------- Stage 2: Production ----------
FROM node:18-alpine

WORKDIR /app

ENV NODE_ENV=production

# Non-root user
RUN addgroup -g 1001 -S nodejs && adduser -S nodeuser -u 1001

# Production dependencies फक्त
COPY package*.json ./
RUN npm ci --omit=dev && npm cache clean --force

# Build stage मधून compiled output copy करा
COPY --from=builder /app/dist ./dist

RUN chown -R nodeuser:nodejs /app
USER nodeuser

EXPOSE 3000

CMD ["npm", "start"]
# ---------- Stage 1: Build ----------
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN NODE_OPTIONS="--max-old-space-size=4096" npm run build

# ---------- Stage 2: Production ----------
FROM node:18-alpine
WORKDIR /app
RUN addgroup -g 1001 -S nodejs && adduser -S nodeuser -u 1001
COPY package*.json ./
RUN npm install --omit=dev && npm cache clean --force
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/src ./src
RUN chown -R nodeuser:nodejs /app
USER nodeuser
ENV NODE_OPTIONS="--max-old-space-size=4096"
EXPOSE 8800
CMD ["node", "dist/app.js"]
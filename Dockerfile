FROM node:20-alpine

WORKDIR /app

# Copy package files
COPY Frontend/package*.json ./

# Install production dependencies
RUN npm ci --omit=dev

# Copy server and built frontend
COPY Frontend/server ./server
COPY Frontend/dist ./dist

# Set environment variables
ENV PORT=4001
ENV NODE_ENV=production

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:4001/health', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})"

# Expose port
EXPOSE 4001

# Start the server. Environment is provided by Docker Compose.
CMD ["node", "server/index.js"]

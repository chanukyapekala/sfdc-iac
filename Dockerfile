FROM node:20-slim

RUN npm install -g @salesforce/cli

WORKDIR /app

CMD ["sf", "--version"]

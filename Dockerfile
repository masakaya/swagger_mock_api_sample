FROM swaggerapi/swagger-codegen-cli:latest as builder
WORKDIR /mock-seed
# ホストマシンのswagger.ymlをコピー
COPY ./swagger.yml ./
WORKDIR /mock-server
# モックサーバーのファイルを作成
RUN java -jar /opt/swagger-codegen-cli/swagger-codegen-cli.jar \
    generate -i /mock-seed/swagger.yml -l nodejs-server -o ./

FROM node:14.2.0-alpine3.10 as executor
WORKDIR /mock-server
# 上記で作ったモックサーバーのファイル群をコピー
COPY --from=builder /mock-server ./
# パッケージ類のインストール
RUN npm install
# 8080ポートを受ける
EXPOSE 8080
# コンテナ起動でサーバーが起動するようにする
CMD ["npm", "start"]
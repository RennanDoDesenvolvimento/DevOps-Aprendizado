FROM python:3.12-alpine

# Define variáveis de ambiente para Python
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copia o arquivo de dependências primeiro para aproveitar o cache do Docker
COPY requirements.txt .

# Instala as dependências
# --no-cache-dir reduz o tamanho da imagem
RUN pip install --no-cache-dir -r requirements.txt

# Adiciona um usuário não-root para segurança
RUN adduser -D appuser
USER appuser

# Copia o restante do código da aplicação
COPY . .

# Expõe a porta 8000, padrão do Uvicorn/FastAPI
EXPOSE 8000

# Comando para iniciar a aplicação
# O host 0.0.0.0 é necessário para que a aplicação seja acessível de fora do contêiner
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
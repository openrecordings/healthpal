FROM redis
RUN ln -sf /dev/stdout /var/log/redis/redis-server.log \
    && ln -sf /dev/stderr /var/log/redis/redis-error.log
EXPOSE 6379
CMD ["redis-server"]

# Railway xray — deploy package (prepared 2026-11-12)
# Trial: $5 / 30 days, no card at signup (per Railway free-trial docs).
# Pattern reused from the proven Cloady node (2026-11-05, usw1, FlClash-verified)
# and the Northflank deploy package:
# xray listens inside the container on $PORT (Railway sets it), TLS is
# terminated at the platform edge, external traffic arrives on 443.
# Railway docs: https://docs.railway.com/pricing/free-trial
#               https://docs.railway.com/pricing/plans
#
# HOW TO USE (for the agent doing the Railway deploy):
# 1. The UUID and WS path below are FRESH, generated 2026-11-12 for Railway.
#    Do NOT reuse the Cloady node's values.
# 2. Put Dockerfile + config.json + entrypoint.sh in a repo (wan's GitHub
#    account) and create a Railway service from that repo, Dockerfile build.
#    Railway sets $PORT; the entrypoint rewrites the xray listen port from it.
# 3. FIRST GATE: if signup or service creation demands a payment card or
#    ID documents, STOP and report — do not add a card or provide ID.
# 4. ACCEPTANCE TEST (the only pass standard): real xray client connects,
#    generate_204 returns 204, and the exit IP matches the Railway datacenter
#    region. Web page loads / port open alone do not count.
# 5. On pass only: deliver the subscription link + QR code + Clash YAML.
#    Mark the expiry: trial ends 30 days after signup or when $5 is spent,
#    whichever first — the node then dies, do not let it roll into a paid plan.
#    On fail: report the confirmed dead end.
#
# COST CHECK (trial $5): metered $20/vCPU-month + $10/GB-month, per minute.
# Near-idle xray should stretch $5 over 30 days, but burn rate is unverified
# — watch the usage dashboard. This is a light-use node, not heavy traffic.
# Railway trial limits: 1 GB RAM, shared vCPU.

# ---- Dockerfile ----
FROM ghcr.io/xtls/xray-core:latest AS xray
FROM alpine:latest
RUN apk add --no-cache ca-certificates
COPY --from=xray /usr/local/bin/xray /usr/local/bin/xray
COPY --from=xray /usr/local/share/xray/geoip.dat /usr/local/share/xray/geoip.dat
COPY --from=xray /usr/local/share/xray/geosite.dat /usr/local/share/xray/geosite.dat
COPY config.json /usr/local/etc/xray/config.json
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
CMD ["/usr/local/bin/entrypoint.sh"]

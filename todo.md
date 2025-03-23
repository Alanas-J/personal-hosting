Learn about mutual TLS

It may be an option to generate certs / insert a CA into containers pre-each deploy
Could even add it into dockerfile builds.

---
CFSSL is a cloudflare tool/library for handling private CAs which might also be useful

Otherwise service meshes are used like 'istio' or 'Linkerd' -- Will likely learn about them as a part of learning kubernetes.

--- 

But currently the thought is to completely regenerate the certificate authority + keys on docker deploy

We can mount all these certs from the host system for simplicity

**This is likely just a temporary measure for me to not need to worry about mutual TLS for the time being**

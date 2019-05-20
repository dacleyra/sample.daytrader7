#IMAGE: Get the base image for Liberty
FROM websphere-liberty:19.0.0.4-kernel

USER 1001
COPY  --chown=1001:0 daytrader-ee7-wlpcfg/servers/daytrader7Sample/apps/daytrader-ee7.ear /config/apps/daytrader-ee7.ear
COPY  --chown=1001:0 daytrader-ee7-wlpcfg/servers/daytrader7Sample/server.xml /config/server.xml
COPY  --chown=1001:0 daytrader-ee7-wlpcfg/shared/resources/Daytrader7SampleDerbyLibs /opt/ibm/wlp/usr/shared/resources/Daytrader7SampleDerbyLibs


ARG HTTP_ENDPOINT=true
ARG SSL=true
ARG MP_MONITORING=true
ARG MP_HEALTHCHECK=true

#HAZELCAST: 
COPY --from=hazelcast/hazelcast --chown=1001:0 /opt/hazelcast/lib/*.jar /opt/ibm/wlp/usr/shared/resources/hazelcast/
# Instruct configure.sh to copy the client topology hazelcast.xml
ARG HZ_SESSION_CACHE=client
RUN configure.sh


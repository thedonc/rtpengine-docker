FROM thedonc/rtpengine:latest
LABEL Donker <>
ADD run.sh /run.sh
RUN chmod 755 /run.sh

CMD /run.sh
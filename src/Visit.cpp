#include "Visit.h"
#include "SocketCommand.h"
#include "WebPage.h"
#include "WebPageManager.h"

Visit::Visit(WebPageManager *manager, QStringList &arguments, QObject *parent) : SocketCommand(manager, arguments, parent) {
}

void Visit::start() {
  QUrl requestedUrl = QUrl::fromEncoded(arguments()[0].toUtf8(), QUrl::StrictMode);
  page()->currentFrame()->load(QUrl(requestedUrl));
  emit finished(new Response(true));
}

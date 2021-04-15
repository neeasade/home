# Quite a lot of settings are from the Kiss Linux's firefox-privacy
# package. See https://github.com/kisslinux/repo/blob/master/extra/firefox-privacy/
{ lib, pkgs, ... }:

{
  enable = false;

  extensions = with pkgs.firefox-addons; [
    ublock-origin
    vimium
    reddit-enhancement-suite
    buster-captcha-solver
    clearurls
    https-everywhere
  ];

  profiles.default = {
    id = 0;
    isDefault = true;
    userChrome = ''
      ${builtins.readFile ./userchrome-chrometabs.css}
      ${builtins.readFile ./userchrome-megabarstyler.css}
    '';
    userContent = ''
      @-moz-document domain("wikipedia.org"),
                     url-prefix("https://en.wikipedia.org/") {
        ${builtins.readFile ./wikitex.css}
      }
      @-moz-document domain("reddit.com"),
                     url-prefix("https://old.reddit.com/"),
                     url-prefix("https://np.reddit.com/"),
                     url-prefix("https://reddit.com/") {
        ${builtins.readFile ./reddit.css}
      }
      @-moz-document domain("discord.com"),
                     url-prefix("https://discord.com/") {
        ${builtins.readFile ./discord.css}
      }
    '';

    settings = {
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "layout.css.moz-document.content.enabled" = true;
      "browser.uiCustomization.state" = builtins.toJSON ({
        "placements" = {
          "widget-overflow-fixed-list" = [];
          "nav-bar" = [
            "back-button"
            "forward-button"
            "stop-reload-button"
            "urlbar-container"
            "_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action"
            "https-everywhere_eff_org-browser-action"
            "ublock0_raymondhill_net-browser-action"
            "_74145f27-f039-47ce-a470-a662b129930a_-browser-action"
            "fxa-toolbar-menu-button"
          ];
          "toolbar-menubar" = [ "menubar-items" ];
          "TabsToolbar" = [
            "tabbrowser-tabs"
            "new-tab-button"
          ];
          "PersonalToolbar" = [
            "personal-bookmarks"
          ];
        };
        "seen" = [
          "developer-button"
          "_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action"
          "https-everywhere_eff_org-browser-action"
          "ublock0_raymondhill_net-browser-action"
          "_74145f27-f039-47ce-a470-a662b129930a_-browser-action"
        ];
        "dirtyAreaCache" = [
          "nav-bar"
          "PersonalToolbar"
          "toolbar-menubar"
          "TabsToolbar"
        ];
        "currentVersion" = 16;
        "newElementCount" = 2;
      });
    };

    settings = {
      "browser.aboutConfig.showWarning" = false;
      "browser.aboutwelcome.enabled" = false;
      "browser.download.animateNotifications" = false;
      "browser.download.useDownloadDir" = false;
      "browser.search.searchEnginesURL" = "https://google.com/search?q=";
      "browser.shell.checkDefaultBrowser" = false;
      "browser.startup.blankWindow" = true;
      "browser.startup.homepage" = "about:blank";
      "browser.tabs.warnOnClose" = false;
      "browser.toolbars.bookmarks.visibility" = "always";
      "browser.urlbar.placeholderName" = "";
      "browser.urlbar.shortcuts.tabs" = false;
      "browser.urlbar.suggest.engines" = false;
      "browser.newtabpage.activity-stream.feeds.telemetry" = false;
      "browser.newtabpage.activity-stream.telemetry" = false;
      "browser.newtabpage.activity-stream.telemetry.ping.endpoint" = false;
      "browser.newtabpage.activity-stream.telemetry.ut.events" = false;
      "browser.newtabpage.activity-stream.telemetry.structuredIntegration" = false;
      "browser.newtabpage.activity-stream.feeds.snippets" = false;
      "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
      "browser.newtabpage.activity-stream.showSearch" = false;
      "browser.newtabpage.activity-stream.showSponsored" = false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      "browser.newtabpage.activity-stream.sectionOrder" = "";
      "device.senors.enabled" = false;
      "devtools.theme" = "light";
      "dom.webnotifications.enabled" = false;
      "geo.enabled" = false;
      "toolkit.cosmeticAnimations.enabled" = false;
      "services.sync.engine.passwords" = false;
      "signon.passwordEditCapture.enabled" = false;
      "signon.autofillForms" = false;
      "signon.formlessCapture.enabled" = false;
      "dom.webnotifications.serviceworker.enabled" = false;
      "permissions.default.desktop-notification" = 2;
      "browser.ui.enabled" = false;
      "camera.control.face_detection.enabled" = false;
      "clipboard.autocopy" = false;
      "extensions.update.enabled" = false;
      "toolkit.tabbox.switchByScrolling" = true;
      "toolkit.telemetry.enable" = false;
      "toolkit.telemetry.unified" = false;
      "toolkit.telemetry.archive.enabled" = false;
      "toolkit.telemetry.newProfilePing.enabled" = false;
      "toolkit.telemetry.shutdownPingSender.enabled" = false;
      "toolkit.telemetry.updatePing.enabled" = false;
      "toolkit.telemetry.bhrPing.enabled" = false;
      "toolkit.telemetry.firstShutdownPing.enabled" = false;
      "toolkit.telemetry.hybridContent.enabled" = false;
      "toolkit.telemetry.coverage.opt-out" = true;
      "toolkit.telemetry.shutdownPingSender.enabledFirstSession" = false;
      "toolkit.telemetry.server_owner" = "";
      "toolkit.telemetry.geckoview.streaming" = false;
      "toolkit.telemetry.ecosystemtelemetry.enabled" = false;
      "toolkit.telemetry.cachedClientID" = "";
      "toolkit.telemetry.enabled" = false;
      "toolkit.telemetry.rejected" = true;
      "toolkit.telemetry.server" = "";
      "toolkit.telemetry.unifiedIsOptIn" = false;
      "toolkit.telemetry.prompted" = 2;
      "security.protectionspopup.recordEventTelemetry" = false;
      "security.identitypopup.recordEventTelemetry" = false;
      "privacy.trackingprotection.origin_telemetry.enabled" = false;
      "privacy.trackingprotection.pbmode.enabled" = false;
      "permissions.eventTelemetry.enabled" = false;
      "toolkit.coverage.opt-out" = true;
      "toolkit.coverage.endpoint.base" = "";
      "startup.homepage_welcome_url.additional" = "";
      "browser.startup.firstrunSkipsHomepage" = true;
      "healthreport.uploadEnabled" = false;
      "social.toast-notifications.enabled" = false;
      "datareporting.healthreport.service.enabled" = false;
      "browser.slowStartup.notificationDisabled" = true;
      "network.http.sendRefererHeader" = 2;
      "network.http.referer.spoofSource" = false;
      "extensions.shield-recipe-client.enabled" =	false;
      "browser.discovery.enabled" = false;
      "browser.tabs.crashReporting.sendReport" = false;
      "captivedetect.canonicalURL" = "";
      "network.captive-portal-service.enabled" = false;
      "network.connectivity-service.enabled" = false;
      "extensions.blocklist.enabled" = false;
      "privacy.announcements.enabled" = false;
      "browser.snippets.enabled" = false;
      "browser.snippets.syncPromo.enabled" = false;
      "browser.snippets.geoUrl" = "http://127.0.0.1/";
      "browser.snippets.updateUrl" = "http://127.0.0.1/";
      "browser.snippets.statsUrl" = "http://127.0.0.1/";
      "browser.urlbar.eventTelemetry.enabled" = false;
      "datareporting.healthreport.uploadEnabled" = false;
      "datareporting.policy.dataSubmissionEnabled" = false;
      "datareporting.healthreport.about.reportUrl" = "127.0.0.1";
      "datareporting.healthreport.documentServerURI" = "127.0.0.1";
      "datareporting.policy.dataSubmissionPolicyBypassNotification" = true;
      "datareporting.policy.firstRunURL" = "";
      "app.shield.optoutstudies.enabled" = false;
      "breakpad.reportURL" = "";
      "browser.crashReports.unsubmittedCheck.enabled" = false;
      "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
      "datareporting.policy.firstRunTime" = 0;
      "datareporting.policy.dataSubmissionPolicyVersion" = 2;
      "browser.webapps.checkForUpdates" = 0;
      "browser.webapps.updateCheckUrl" = "http://127.0.0.1/";
      "browser.aboutHomeSnippets.updateUrl" = "nonexistent://test";
      "browser.newtabpage.activity-stream.default.sites" = "";
      "browser.newtabpage.activity-stream.tippyTop.service.endpoint" = "";
      "browser.uitour.pinnedTabUrl" = "";
      "browser.uitour.url" = "";
      "browser.search.isUS" = true;
      "browser.search.countryCode" = "US";
      "browser.ping-centre.staging.endpoint" = "";
      "browser.ping-centre.production.endpoint" = "";
      "browser.contentblocking.report.monitor.sign_in_url" = "";
      "browser.contentblocking.report.monitor.url" = "";
      "identity.fxaccounts.service.monitorLoginUrl" = "";
      "network.trr.resolvers" = "";
      "network.trr.uri" = "";
      "security.certerrors.mitm.priming.endpoint" = "";
      "signon.management.page.breachAlertUrl" = "";
      "network.connectivity-service.IPv4.url" = "";
      "network.connectivity-service.IPv6.url" = "";
      "accessibility.support.url" = "";
      "app.feedback.baseURL" = "";
      "app.normandy.shieldLearnMoreUrl" = "";
      "app.update.url" = "";
      "browser.chrome.errorReporter.infoURL" = "";
      "browser.contentblocking.report.cookie.url" = "";
      "browser.dictionaries.download.url" = "";
      "browser.safebrowsing.provider.google.reportMalwareMistakeURL" = "";
      "browser.safebrowsing.provider.google.reportPhishMistakeURL" = "";
      "browser.safebrowsing.provider.google.reportURL" = "";
      "browser.safebrowsing.provider.google4.dataSharingURL" = "";
      "browser.safebrowsing.provider.google4.reportMalwareMistakeURL" = "";
      "browser.safebrowsing.provider.google4.reportPhishMistakeURL" = "";
      "browser.safebrowsing.provider.google4.reportURL" = "";
      "browser.safebrowsing.reportPhishURL" = "";
      "devtools.devices.url" = "";
      "devtools.performance.recording.ui-base-url" = "";
      "devtools.webide.templatesURL" = "";
      "extensions.getAddons.compatOverides.url" = "";
      "extensions.getAddons.discovery.api_url" = "";
      "extensions.getAddons.langpacks.url" = "";
      "extensions.recommendations.themeRecommendationUrl" = "";
      "gecko.handlerService.schemes.webcal.0.name" = "";
      "gecko.handlerService.schemes.webcal.0.uriTemplate" = "";
      "gecko.handlerService.schemes.irc.0.name" = "";
      "gecko.handlerService.schemes.irc.0.uriTemplate" = "";
      "media.gmp-manager.url" = "";
      "dom.flyweb.enabled" = false;
      "extensions.systemAddon.update.enabled" = false;
      # "layout.css.devPixelsPerPx" = "1.1";
    };
  };
}

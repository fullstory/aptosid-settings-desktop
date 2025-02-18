// loadTemplate("org.kde.plasma.desktop.defaultPanel")

var widgets = [
    "org.kde.plasma.kicker",
    "org.kde.plasma.activitypager",
    "org.kde.plasma.marginsseparator",
    "org.kde.plasma.icontasks",
    "org.kde.plasma.systemtray",
    "org.kde.plasma.digitalclock",
    "org.kde.plasma.showdesktop"
];

var desktopsArray = desktopsForActivity(currentActivity());
for( var j = 0; j < desktopsArray.length; j++) {
    var newPanel = new Panel;
    newPanel.location = "bottom";
    newPanel.height = 48;
    newPanel.screen = j;
    for (const widgetType of widgets) {
        newPanel.addWidget(widgetType);
    }
    for (const widget of newPanel.widgets()) {
        if (widget.type === "org.kde.plasma.icontasks") {
            var launchers = [
                "applications:aptosid-xdg-browser-launcher.desktop",
                "applications:org.kde.konsole.desktop",
                "applications:org.kde.dolphin.desktop"
            ]
            widget.currentConfigGroup = ["General"];
            widget.writeConfig("launchers", launchers.join(","));
            widget.writeConfig("launchers", launchers.join(","));
            widget.reloadConfig();
        }
    }
    desktopsArray[j].wallpaperPlugin = 'org.kde.image';
}

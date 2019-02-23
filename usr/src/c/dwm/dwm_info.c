void
init_dwm_info(const int gappx, const int BAR_HEIGHT, const int barpos, const int num_ws, const int borderpx, const int bar_gaps)
{
    system("[ -d /tmp/dwm_info ] && rm -rf /tmp/dwm_info");
    mkdir("/tmp/dwm_info", 0777);

    for(int i = 1; i < NUM_WORKSPACES; i++) {
        char buf[20];
        snprintf(buf, sizeof(buf), "/tmp/dwm_info/ws%d", i);
        FILE *f = fopen(buf, "w");
        if(f) {
            fprintf(f, "%d", 0);
            fclose(f);
        }
    }
    FILE *fCWS = fopen("/tmp/dwm_info/current_ws", "w"); fprintf(fCWS, "1"); fclose(fCWS);
    FILE *fCL = fopen("/tmp/dwm_info/current_layout", "w"); fprintf(fCL, "0"); fclose(fCL);
    FILE *fCHECK = fopen("/tmp/dwm_info/check", "w"); fprintf(fCHECK, "1"); fclose(fCHECK);

    FILE *fgappx = fopen("/tmp/dwm_info/gappx", "w"); fprintf(fgappx, "%d", gappx); fclose(fgappx);
    FILE *fborderpx = fopen("/tmp/dwm_info/borderpx", "w"); fprintf(fborderpx, "%d", borderpx); fclose(fborderpx);
    FILE *fbar_height = fopen("/tmp/dwm_info/bar_height", "w"); fprintf(fgappx, "%d", BAR_HEIGHT); fclose(fbar_height);
    FILE *ftop_bar = fopen("/tmp/dwm_info/barpos", "w"); fprintf(fgappx, "%d", barpos); fclose(ftop_bar);
    FILE *fbar_gaps = fopen("/tmp/dwm_info/bar_gaps", "w"); fprintf(fbar_gaps, "%d", bar_gaps); fclose(fborderpx);

    FILE *fnum_ws = fopen("/tmp/dwm_info/num_ws", "w"); fprintf(fnum_ws, "%d", num_ws); fclose(fnum_ws);

}

void
set_dwm_info_current_workspace(int i)
{
    FILE *f = fopen("/tmp/dwm_info/current_ws", "w");
    fprintf(f, "%d", i);
    fclose(f);
    FILE *fCHECK = fopen("/tmp/dwm_info/check", "w"); fprintf(fCHECK, "1"); fclose(fCHECK);
}

void
set_dwm_info_current_layout(char* i)
{
    // sets index of current layout in layouts[]
    FILE *f = fopen("/tmp/dwm_info/current_layout", "w");
    fprintf(f, "%s", i);
    fclose(f);
    FILE *fCHECK = fopen("/tmp/dwm_info/check", "w"); fprintf(fCHECK, "1"); fclose(fCHECK);
}

void
toggle_dwm_info_ws(int ws, int bool)
{
    // toggles whether the given tag has clients or not
    // NOTE: bool should only be either '1' or 0'
    char buf[20];
    snprintf(buf, sizeof(buf), "/tmp/dwm_info/ws%d", ws);
    FILE *f = fopen(buf, "w");

    if(f) {
        fprintf(f, "%d", bool);
        fclose(f);
    }

    FILE *fCHECK = fopen("/tmp/dwm_info/check", "w"); fprintf(fCHECK, "1"); fclose(fCHECK);
}
/* function declarations */
static void tile(Monitor *);
static void monocle(Monitor *m);
static void bstack(Monitor *m);
static void deck(Monitor *m);

void
tile(Monitor *m)
{
	unsigned int i, n, h, mw, my, ty, ns;
	float mfacts = 0, sfacts = 0;
	Client *c;

	for (n = 0, c = nexttiled(m->clients); c; c = nexttiled(c->next), n++) {
        if (n < m->nmaster)
			mfacts += c->cfact;
		else
			sfacts += c->cfact;
	}
	if (n == 0)
		return;

    if (n > m->nmaster) {
		mw = m->nmaster ? m->ww * m->mfact : 0;
        ns = m->nmaster > 0 ? 2 : 1;
    } else  {
		mw = m->ww;
        ns = 1;
    }

	for (i = 0, my = ty = gappx, c = nexttiled(m->clients); c; c = nexttiled(c->next), i++)
		if (i < m->nmaster) {
			h = (m->wh - my) * (c->cfact / mfacts) - gappx;
			resize(c, m->wx + gappx, m->wy + my, mw - (2*c->bw) - gappx*(5-ns)/2, h - (2*c->bw));
			my += HEIGHT(c) + gappx;
			mfacts -= c->cfact;
		} else {
			h = (m->wh - ty) * (c->cfact / sfacts) - gappx;
			resize(c, m->wx + mw + gappx/ns, m->wy + ty, m->ww - mw - (2*c->bw) - gappx*(5-ns)/2, h - (2*c->bw));
			ty += HEIGHT(c) + gappx;
			sfacts -= c->cfact;
		}
}

void
monocle(Monitor *m)
{
	unsigned int n = 0;
	Client *c;

	for (c = m->clients; c; c = c->next)
		if (ISVISIBLE(c))
			n++;

	if (n > 0) /* override layout symbol */
		snprintf(m->ltsymbol, sizeof m->ltsymbol, "[%d]", n);
    else /* need this for the fifo. */
        snprintf(m->ltsymbol, sizeof m->ltsymbol, "[M]");
    for (c = nexttiled(m->clients); c; c = nexttiled(c->next)) {
        resize(c, m->wx + gappx, m->wy + gappx, m->ww - 2 * c->bw - 2 * gappx, m->wh -2 * c->bw - 2 * gappx);
    }
}

void
bstack(Monitor *m) {
	int w, h, mh, mx, tx, ty, tw;
	unsigned int i, n;
	Client *c;

	for (n = 0, c = nexttiled(m->clients); c; c = nexttiled(c->next), n++);
	if (n == 0)
		return;
	if (n > m->nmaster) { /* there are clients in the stack */
		mh = m->nmaster ? m->mfact * m->wh : gappx;
		tw = (m->ww - (n - m->nmaster + 1) * gappx) / (n - m->nmaster);
		ty = m->wy + mh + gappx;
	} else {
		mh = m->wh;
		tw = m->ww;
		ty = m->wy;
	}
	for (i = 0, mx = tx = gappx, c = nexttiled(m->clients); c; c = nexttiled(c->next), i++) {
		if (i < m->nmaster) { // Modifies master windows
			w = (m->ww - mx) / (MIN(n, m->nmaster) - i) - gappx;
			resize(c, m->wx + mx, m->wy + gappx, w - (2 * c->bw), mh - 2 * (c->bw + gappx));
			mx += WIDTH(c) + gappx;
		} else { // Modifies stack windows
			h = m->wh - mh - gappx;
            if (barpos == 2) tx = m->wx + gappx;
			resize(c, tx, ty - gappx, tw - (2 * c->bw), h - (2 * c->bw));
			if (tw != m->ww) // if there's more than one client in the stack!
				tx += WIDTH(c) + gappx;
		}
	}
}

void
deck(Monitor *m)
{
	int dn;
	unsigned int i, n, h, mw, my, ns;
	Client *c;

	for(n = 0, c = nexttiled(m->clients); c; c = nexttiled(c->next), n++);
	if(n == 0)
		return;

	dn = n - m->nmaster;
	if(dn > 0) /* override layout symbol */
		snprintf(m->ltsymbol, sizeof m->ltsymbol, "[] %d", dn);

    if(n > m->nmaster) {
		mw = m->nmaster ? m->ww * m->mfact : 0;
        ns = m->nmaster > 0 ? 2 : 1;
    }
    else {
		mw = m->ww;
        ns = 1;
    }

	for(i = 0, my = gappx, c = nexttiled(m->clients); c; c = nexttiled(c->next), i++)
		if(i < m->nmaster) {
			h = (m->wh - my) / (MIN(n, m->nmaster) - i) - gappx;
			resize(c, m->wx + gappx, m->wy + my, mw - (2*c->bw) - gappx*(5-ns)/2, h - (2*c->bw));
			my += HEIGHT(c) + gappx;
		}
		else
			resize(c, m->wx + mw + gappx/ns, m->wy + gappx, m->ww - mw - (2*c->bw) - gappx*(5-ns)/2, m->wh - (2*c->bw) - gappx*2);
}

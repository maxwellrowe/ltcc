document.addEventListener("DOMContentLoaded", () => {
    const sidenav = document.querySelector(".sidenav");
    if (!sidenav) return;

    /**
     * Wrap consecutive direct-child <li> elements in a <ul>.
     */
    const wrapOrphanListItems = (container) => {
        const children = Array.from(container.children);
        let wrapper = null;

        children.forEach((child) => {
            if (child.tagName === "LI") {
                if (!wrapper) {
                    wrapper = document.createElement("ul");
                    container.insertBefore(wrapper, child);
                }

                wrapper.appendChild(child);
            } else {
                wrapper = null;
            }
        });
    };

    const normalizePath = (url) => {
        try {
            const path = new URL(url, window.location.origin)
                .pathname
                .replace(/\/index\.(php|html|htm)$/i, "")
                .replace(/\/+$/, "");

            return path || "/";
        } catch {
            return "";
        }
    };

    const isRealLink = (link) => {
        const href = link.getAttribute("href");

        return (
            href &&
            href !== "#" &&
            !href.toLowerCase().startsWith("javascript:")
        );
    };

    // Fix top-level orphaned <li> elements.
    wrapOrphanListItems(sidenav);

    // Fix nested orphaned <li> elements.
    sidenav.querySelectorAll("li").forEach((li) => {
        wrapOrphanListItems(li);
    });

    const nav = sidenav.querySelector(":scope > ul");

    if (!nav) {
        requestAnimationFrame(() => {
            sidenav.classList.add("is-ready");
        });

        return;
    }

    const currentPath = normalizePath(window.location.href);

    /*
     * Find and mark the current page independently of whether
     * its <li> has child navigation.
     */
    nav.querySelectorAll("a").forEach((link) => {
        if (!isRealLink(link)) return;

        const linkPath = normalizePath(link.href);

        if (linkPath !== currentPath) return;

        const currentLi = link.closest("li");

        link.classList.add("current");
        link.setAttribute("aria-current", "page");
        currentLi?.classList.add("current");

        // Open every ancestor navigation item.
        let ancestorLi = currentLi?.parentElement?.closest("li");

        while (ancestorLi && nav.contains(ancestorLi)) {
            ancestorLi.classList.add("active");
            ancestorLi = ancestorLi.parentElement?.closest("li");
        }
    });

    /*
     * Add parent-navigation behavior only to items that
     * contain a direct child <ul>.
     */
    nav.querySelectorAll("li").forEach((li) => {
        const childUl = li.querySelector(":scope > ul");
        const parentLink = li.querySelector(":scope > a");

        if (!childUl) return;

        li.classList.add("has-children");

        if (parentLink) {
            parentLink.addEventListener("click", (event) => {
                const href = parentLink.getAttribute("href");

                if (!href || href === "#") {
                    event.preventDefault();
                    li.classList.toggle("active");
                }
            });
        }
    });

    requestAnimationFrame(() => {
        sidenav.classList.add("is-ready");
    });
});
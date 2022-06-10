---
layout: default
title: Home
nav_order: 1
description: "Welcome to the TAE Course Guide."
permalink: /
---

## Welcome to the TAE Course Guide

This site will guide you through the set-up of the needed Linux environment and the installation of the tools needed throughout the TAE Course.

Use the sidebar to navigate the guide, or use the search bar to look for a specific topic.

### Support or Contact

Having trouble following the guide? Send us a dm, and we'll be glad to help.
<button class="btn js-toggle-dark-mode">Preview dark color scheme</button>

<script>
const toggleDarkMode = document.querySelector('.js-toggle-dark-mode');

jtd.addEvent(toggleDarkMode, 'click', function(){
  if (jtd.getTheme() === 'dark') {
    jtd.setTheme('light');
    toggleDarkMode.textContent = 'Preview dark color scheme';
  } else {
    jtd.setTheme('dark');
    toggleDarkMode.textContent = 'Return to the light side';
  }
});
</script>
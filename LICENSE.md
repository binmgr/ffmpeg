# FFmpeg License

This project builds and distributes FFmpeg binaries. FFmpeg is licensed under the **GNU Lesser General Public License (LGPL) version 2.1** or later, with some optional components licensed under the **GNU General Public License (GPL) version 2** or later.

## FFmpeg Licensing

FFmpeg is a trademark of Fabrice Bellard, originator of the FFmpeg project.

### LGPL v2.1+ (Default)

```
FFmpeg is free software; you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation; either version 2.1 of the License, or
(at your option) any later version.

FFmpeg is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with FFmpeg; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
```

### GPL v2+ (When GPL components enabled)

When FFmpeg is built with GPL-licensed optional components (such as x264, x265, fdk-aac with GPL, etc.), the resulting binary is licensed under **GPL v2 or later**:

```
FFmpeg is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

FFmpeg is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with FFmpeg; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
```

## Binary Distribution Notice

**The binaries distributed by this project are built with GPL-licensed components and are therefore licensed under GPL v2 or later.**

### Included GPL Components

The static builds include the following GPL-licensed libraries:

| Library | License | Purpose |
|---------|---------|---------|
| x264 | GPL v2+ | H.264/AVC encoder |
| x265 | GPL v2+ | H.265/HEVC encoder |
| fdk-aac | GPL v2+ (when used with GPL) | AAC encoder |
| libvidstab | GPL v2+ | Video stabilization |
| rubberband | GPL v2+ | Audio time-stretching |

### Included LGPL Components

| Library | License | Purpose |
|---------|---------|---------|
| lame | LGPL v2+ | MP3 encoder |
| opus | BSD | Opus codec |
| vorbis | BSD | Vorbis codec |
| vpx | BSD | VP8/VP9 codec |
| aom | BSD | AV1 codec |
| dav1d | BSD | AV1 decoder |
| svtav1 | BSD | AV1 encoder |
| zimg | WTFPL | Image processing |

## Source Code Availability

As required by the GPL, the complete source code for FFmpeg and all included libraries is available at:

- **FFmpeg**: https://ffmpeg.org/download.html
- **Build scripts**: This repository contains all scripts used to build these binaries

## Full License Texts

- [GNU Lesser General Public License v2.1](https://www.gnu.org/licenses/old-licenses/lgpl-2.1.html)
- [GNU General Public License v2](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html)

## This Repository

The build scripts and CI/CD configurations in this repository are licensed under the **MIT License**:

```
MIT License

Copyright (c) 2024 Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## Patent Notice

Some codecs included in FFmpeg may be covered by patents. Users are responsible for ensuring compliance with applicable patent laws in their jurisdiction. Notable patent considerations:

- **H.264/AVC**: Covered by patents held by MPEG LA
- **H.265/HEVC**: Covered by patents held by multiple patent pools
- **AAC**: Covered by patents held by Via Licensing

Use of these codecs may require patent licenses depending on your use case and jurisdiction.

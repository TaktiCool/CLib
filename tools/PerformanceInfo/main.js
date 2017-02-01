class Timeline {
    constructor(element, data) {
        this.$canvas = $(element);
        this.canvas = this.$canvas[0];
        this.ctx = this.canvas.getContext('2d');

        this.data = data;
        this.lastMousePosition = [0, 0];
        this.lines = {};
        this.rectangles = {};
        this.texts = {};

        this.$canvas.attr('height', this.$canvas.css('height'));
        this.$canvas.attr('width', this.$canvas.css('width'));
        this.$canvas.mousemove(this.trackMouse.bind(this));

        this.render();
    }

    trackMouse(mouse) {
        this.lastMousePosition = [mouse.offsetX, mouse.offsetY];
    }

    addLine(name, start, end, color) {
        this.lines[name] = {
            start: start,
            end: end,
            color: color
        };
    }

    removeLine(name) {
        delete this.lines[name];
    }

    addRectangle(name, position, size, color, hoverColor = color, tooltip = "") {
        this.rectangles[name] = {
            position: position,
            size: size,
            color: color,
            hoverColor: hoverColor,
            tooltip: tooltip
        };
    }

    removeRectangle(name) {
        delete this.rectangles[name];
    }

    addText(name, position, text) {
        this.texts[name] = {
            position: position,
            text: text
        };
    }

    removeText(name) {
        delete this.texts[name];
    }

    render() {
        requestAnimationFrame(this.render.bind(this));
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);

        for (let lineName in this.lines) {
            if (!this.lines.hasOwnProperty(lineName)) continue;

            const line = this.lines[lineName];

            this.ctx.strokeStyle = line.color;
            this.ctx.beginPath();
            this.ctx.moveTo.apply(this.ctx, line.start);
            this.ctx.lineTo.apply(this.ctx, line.end);
            this.ctx.stroke();
        }

        let tooltipVisible = false;
        for (let rectName in this.rectangles) {
            if (!this.rectangles.hasOwnProperty(rectName)) continue;

            const rectangle = this.rectangles[rectName];

            this.ctx.fillStyle = rectangle.color;
            if (this.lastMousePosition[0] > rectangle.position[0] && this.lastMousePosition[0] < (rectangle.position[0] + rectangle.size[0])
                && this.lastMousePosition[1] > rectangle.position[1] && this.lastMousePosition[1] < (rectangle.position[1] + rectangle.size[1])) {
                this.ctx.fillStyle = rectangle.hoverColor;
                this.addText('tooltip', this.lastMousePosition, rectangle.tooltip);
                tooltipVisible = true;
            }

            this.ctx.fillRect(rectangle.position[0], rectangle.position[1], rectangle.size[0], rectangle.size[1]);
        }

        if (!tooltipVisible)
            this.removeText('tooltip');

        for (let textName in this.texts) {
            if (!this.texts.hasOwnProperty(textName)) continue;

            const text = this.texts[textName];

            this.ctx.fillStyle = 'black';
            this.ctx.fillText(text.text, text.position[0], text.position[1]);
        }
    }
}

class Detailview extends Timeline {
    constructor(element, data) {
        super(element, data);

        this.scale = 1;
        this.selectedAreaStart = 0;
        this.selectedAreaEnd = 0;
        this.dragOldMousePosX = null;

        this.$canvas.mousedown(this.startDrag.bind(this));
        this.$canvas.mousemove(this.drag.bind(this));
        this.$canvas.mouseup(this.stopDrag.bind(this));
    }

    drawRange(start, end) {
        this.selectedAreaStart = start;
        this.selectedAreaEnd = end;

        const length = this.data.length;
        this.scale = this.canvas.width / (this.selectedAreaEnd - this.selectedAreaStart);

        const scope = [];
        let lastFrame = 0;
        for (let i = 0; i < length; i++) {
            this.removeRectangle('data' + i);

            const current = this.data[i];
            const currentEnd = parseFloat(current[0]) + parseFloat(current[1][4]);
            if (currentEnd < this.selectedAreaStart || current[0] > this.selectedAreaEnd) {
                this.removeLine('frame' + current[1][2]);
                continue;
            };

            if (current[1][2] > lastFrame) {
                this.addLine('frame' + lastFrame, [(current[0] - this.selectedAreaStart) * this.scale, 0], [(current[0] - this.selectedAreaStart) * this.scale, this.canvas.height], 'pink');
                lastFrame = current[1][2];
            }

            while (scope.length && scope[scope.length - 1] <= current[0])
                scope.pop();

            let color = ['rgb(240, 196, 87)', 'rgb(203, 181, 114)'];
            if (current[1][5].indexOf('CLib') == 0)
                color = ['rgb(192, 214, 242)', 'rgb(165, 195, 238)'];
            this.addRectangle('data' + i, [(current[0] - this.selectedAreaStart) * this.scale, 30 + scope.length * 41], [current[1][4] * this.scale, 40], color[0], color[1], current[1][5]);
            scope.push(currentEnd);
        }
    }

    startDrag(mouse) {
        this.dragOldMousePosX = mouse.offsetX;

        this.$canvas.css('cursor', '-webkit-grabbing');
    }

    drag(mouse) {
        if (!this.dragOldMousePosX) return;

        const mouseXDiff = (this.dragOldMousePosX - mouse.offsetX) / this.scale;
        this.drawRange(this.selectedAreaStart + mouseXDiff, this.selectedAreaEnd + mouseXDiff);

        this.dragOldMousePosX = mouse.offsetX;
    }

    stopDrag() {
        this.dragOldMousePosX = null;
        this.$canvas.css('cursor', 'default');
    }
}

class Overview extends Timeline {
    constructor(timelineElement, detailviewElement, data) {
        super(timelineElement, data);

        this.detailview = new Detailview(detailviewElement, data);

        this.scale = 1;
        this.dragStartPoint = null;

        this.$canvas.css('cursor', 'text');

        this.$canvas.mousemove(this.drawCursor.bind(this));
        this.$canvas.mouseleave(this.removeCursor.bind(this));
        this.$canvas.mousedown(this.startDrag.bind(this));
        this.$canvas.mouseup(this.stopDrag.bind(this));

        this.drawData();
    }

    drawData() {
        const length = this.data.length;
        const last = this.data[length - 1];
        const lastEnd = parseFloat(last[0]) + parseFloat(last[1][4]);

        this.scale = this.canvas.width / lastEnd;

        for (let i = 0; i < length; i++) {
            const current = this.data[i];
            this.addRectangle('data' + i, [current[0] * this.scale, 30], [current[1][4] * this.scale, 40], 'rgba(0, 100, 0, 0.1)');
        }

        const gridStep = Math.round(lastEnd / 160) * 10;
        for (let i = 0; i < lastEnd; i += gridStep) {
            this.addLine('grid' + i, [i * this.scale, 0], [i * this.scale, this.canvas.height], 'rgba(0, 0, 0, 0.1)');
            this.addText('grid' + i, [i * this.scale + 2, 12], i + 's');
        }

        this.detailview.drawRange(0, lastEnd);
    }

    drawCursor(mouse) {
        this.addLine('cursor', [mouse.offsetX + 1, 0], [mouse.offsetX + 1, this.canvas.height], 'rgb(0, 68, 187)');
        if (this.dragStartPoint)
            this.addRectangle('cursorArea', [this.dragStartPoint, 0], [mouse.offsetX - this.dragStartPoint, this.canvas.height], 'rgba(0, 128, 187, 0.2)');
    }

    removeCursor() {
        this.removeLine('cursor');
    }

    startDrag(mouse) {
        this.dragStartPoint = mouse.offsetX + 1;
    }

    stopDrag(mouse) {
        let leftPoint = this.dragStartPoint;
        let rightPoint = mouse.offsetX;
        if (mouse.offsetX < this.dragStartPoint) {
            leftPoint = mouse.offsetX;
            rightPoint = this.dragStartPoint;
        }

        this.addRectangle('selectedAreaLeft', [0, 0], [leftPoint, this.canvas.height], 'rgba(0, 0, 0, 0.1)');
        this.addRectangle('selectedAreaRight', [rightPoint, 0], [this.canvas.width, this.canvas.height], 'rgba(0, 0, 0, 0.1)');

        this.detailview.drawRange(leftPoint / this.scale, rightPoint / this.scale);

        this.dragStartPoint = null;
        this.removeRectangle('cursorArea');
    }
}

$($ => {
    $('#file').change(e => {
        const reader = new FileReader();

        let callCounter = {};

        reader.onload = e => {
            let allData = e.target.result.split('\r\n').map(x => x.split(':'));

            let dataCache = [];
            for (let i = 0, len = allData.length - 1; i < len; i++) {
                if (allData[i][4] == 0) continue;
                dataCache.push([allData[i][0] - allData[i][4], allData[i]]);
            }
            console.log(callCounter);
            dataCache = dataCache.sort((a, b) => {
                return a[0] - b[0];
            });

            const overview = new Overview('#overview', '#detailview', dataCache);
        };

        reader.readAsText(e.currentTarget.files[0]);
    });
});
import { Controller } from  "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ 'view', 'container']

    show() {
        $(this.viewTarget).fadeIn();
    }

    hide() {
        $(this.viewTarget).fadeOut();
    }

    moveStart(event) {
        this.offsetX = event.offsetX;
        this.offsetY = event.offsetY;
        this.clientX = event.clientX;
        this.clientY = event.clientY;
    }
    
    move(event) {
       this.containerTarget.style.top = event.clientY-this.offsetY+'px';
       this.containerTarget.style.left = event.clientX-this.offsetX+'px';
    }

}
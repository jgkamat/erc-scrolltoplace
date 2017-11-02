;;; erc-scrolltoplace.el --- An Erc module to scroll to bottom better -*- lexical-binding: t; -*-

;; Copyright (C) 2016-2017 Jay Kamat
;; Author: Jay Kamat <jaygkamat@gmail.com>
;; Version: 0.0.1
;; Keywords: erc, module, scrolltobottom
;; URL: http://github.com/jgkamat/erc-scrolltoplace
;; Package-Requires: ((emacs "24.0"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;; TODO provide commentary
;;
;; Variables:

;;; Constants:

;;; Code:

(require 'erc)

(define-erc-module scrolltoplace nil
  "This mode causes the prompt to stay at the end of the window."
  ((add-hook 'erc-mode-hook 'erc-add-scroll-to-place)
   (dolist (buffer (erc-buffer-list))
     (with-current-buffer buffer
       (erc-add-scroll-to-place))))
  ((remove-hook 'erc-mode-hook 'erc-add-scroll-to-place)
   (dolist (buffer (erc-buffer-list))
     (with-current-buffer buffer
       (remove-hook 'post-command-hook 'erc-scroll-to-place t)))))

(defun erc-add-scroll-to-place ()
  "A hook function for `erc-mode-hook' to recenter output at a 'good place'.
If you find that ERC hangs when using this function, try customizing
the value of `erc-input-line-position'.
This works whenever scrolling happens, so it's added to
`window-scroll-functions' rather than `erc-insert-post-hook'."
  (add-hook 'post-command-hook 'erc-scroll-to-place nil t))

(defun erc-scroll-to-place ()
  "Recenter WINDOW so that `point' is on the last line.
This is added to `window-scroll-functions' by `erc-add-scroll-to-place'.
You can control which line is recentered to by customizing the
variable `erc-input-line-position'."
      ;; Temporarily bind resize-mini-windows to nil so that users who have it
      ;; set to a non-nil value will not suffer from premature minibuffer
      ;; shrinkage due to the below recenter call.  I have no idea why this
      ;; works, but it solves the problem, and has no negative side effects.
      ;; (Fran Litterio, 2003/01/07)
  (let ((resize-mini-windows nil))
    (save-restriction
      (widen)
      (when (and erc-insert-marker
		 ;; we're editing a line. Scroll.
		 (> (point) erc-insert-marker))
	(save-excursion
	  (goto-char (point-max))
	  (recenter (or erc-input-line-position -1)))))))

(provide 'erc-scrolltoplace)

;;; erc-scrolltoplace.el ends here

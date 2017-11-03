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
(require 'switch-buffer-functions)

(define-erc-module scrolltoplace nil
  "Leave point above un-viewed text in other channels."
  ((add-hook 'erc-insert-post-hook 'erc-scroll-to-place)
   (add-hook 'switch-buffer-functions 'erc--scroll-to-place-check-erc))
  ((remove-hook 'erc-insert-post-hook 'erc-scroll-to-place)
   (remove-hook 'switch-buffer-functions 'erc--scroll-to-place-check-erc)))

(defun erc--scroll-to-place-check-erc (_from _to)
  "Run `erc-scroll-to-place' if we are switching to an erc buffer."
  (when (eq major-mode 'erc-mode)
    (erc-scroll-to-place)))

(defun erc-scroll-to-place ()
  "Recenter WINDOW so that `point' is visible, but we can see as much conversation as possible."

  ;; Temporarily bind resize-mini-windows to nil so that users who have it
  ;; set to a non-nil value will not suffer from premature minibuffer
  ;; shrinkage due to the below recenter call.  I have no idea why this
  ;; works, but it solves the problem, and has no negative side effects.
  ;; (Fran Litterio, 2003/01/07)
  (let ((resize-mini-windows nil))
    ;; Only run if current buffer is visible
    (when (or (eq (current-buffer) (window-buffer (selected-window)))
              (get-buffer-window (current-buffer)))
      (save-restriction
        (widen)
        (save-excursion
          (goto-char (point-max))
          (recenter-top-bottom -1))))))

(provide 'erc-scrolltoplace)

;;; erc-scrolltoplace.el ends here

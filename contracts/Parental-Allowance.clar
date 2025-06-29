(define-constant contract-owner tx-sender)
(define-constant allowance-amount u1000000) ;; 1 STX

(define-map children principal bool)
(define-map paused principal bool)
(define-map last-paid principal uint)

;; Register a child
(define-public (register-child (child principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) (err "Only parent can register"))
    (asserts! (is-none (map-get? children child)) (err "Child already registered"))
    (map-set children child true)
    (ok "Child registered")
  )
)

;; Pause a child's allowance
(define-public (pause-allowance (child principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) (err "Only parent can pause"))
    (asserts! (is-some (map-get? children child)) (err "Child not registered"))
    (map-set paused child true)
    (ok "Allowance paused")
  )
)

;; Unpause a child's allowance
(define-public (resume-allowance (child principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) (err "Only parent can resume"))
    (asserts! (is-some (map-get? children child)) (err "Child not registered"))
    (map-delete paused child)
    (ok "Allowance resumed")
  )
)

;; Send weekly allowance to all registered children
(define-public (send-weekly (child principal) (current-block uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) (err "Only parent can send allowance"))
    (asserts! (is-some (map-get? children child)) (err "Not a registered child"))
    (asserts! (is-none (map-get? paused child)) (err "Child is paused"))

    (let ((last-block (default-to u0 (map-get? last-paid child))))
      (asserts! (>= (- current-block last-block) u144) (err "Too early to send again"))
      (let ((transfer-result (stx-transfer? allowance-amount contract-owner child)))
        (if (is-ok transfer-result)
            (begin
              (map-set last-paid child current-block)
              (ok "Allowance sent")
            )
            (err "Transfer failed")
        )
      )
    )
  )
)

;; Check if child is paused
(define-read-only (is-paused (child principal))
  (is-some (map-get? paused child))
)

;; Get last payment block height
(define-read-only (get-last-paid (child principal))
  (default-to u0 (map-get? last-paid child))
)

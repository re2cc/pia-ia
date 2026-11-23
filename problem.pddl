(define (problem recover-overheated-reactor)
  (:domain reactor-maintenance)

  (:objects
    unit-1 - reactor
    reactor-water-tank - tank
    reactor-sensors - sensor-array
  )

  (:init
    (online unit-1)
    (overheated unit-1)
    (sensor-inspection-pending reactor-sensors)
    (tank-serves reactor-water-tank unit-1)
    (sensors-monitor reactor-sensors unit-1)
  )

  (:goal (and
    (online unit-1)
    (not (overheated unit-1))
    (not (sensor-inspection-pending reactor-sensors))
  ))
)

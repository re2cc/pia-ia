(define (domain reactor-maintenance)
  (:requirements :strips :typing :negative-preconditions :conditional-effects)
  (:types reactor tank sensor-array)

  (:predicates
    (online ?reactor - reactor)
    (tank-full ?tank - tank)
    (overheated ?reactor - reactor)
    (sensor-inspection-pending ?sensors - sensor-array)
    (tank-serves ?tank - tank ?reactor - reactor)
    (sensors-monitor ?sensors - sensor-array ?reactor - reactor)
  )

  (:action take-offline
    :parameters (?reactor - reactor)
    :precondition (and
      (online ?reactor)
      (not (overheated ?reactor))
    )
    :effect (not (online ?reactor))
  )

  (:action turn-online
    :parameters (?reactor - reactor ?tank - tank ?sensors - sensor-array)
    :precondition (and
      (tank-serves ?tank ?reactor)
      (sensors-monitor ?sensors ?reactor)
      (not (online ?reactor))
      (not (overheated ?reactor))
    )
    :effect (and
      (online ?reactor)
      (when (not (tank-full ?tank))
        (and
          (overheated ?reactor)
          (sensor-inspection-pending ?sensors)
        )
      )
    )
  )

  (:action drain-tank
    :parameters (?tank - tank ?reactor - reactor ?sensors - sensor-array)
    :precondition (and
      (tank-serves ?tank ?reactor)
      (sensors-monitor ?sensors ?reactor)
      (tank-full ?tank)
      (not (overheated ?reactor))
    )
    :effect (and
      (not (tank-full ?tank))
      (when (online ?reactor)
        (and
          (overheated ?reactor)
          (sensor-inspection-pending ?sensors)
        )
      )
    )
  )

  (:action add-water
    :parameters (?tank - tank ?reactor - reactor)
    :precondition (and
      (tank-serves ?tank ?reactor)
      (not (tank-full ?tank))
    )
    :effect (and
      (tank-full ?tank)
      (not (overheated ?reactor))
    )
  )

  (:action inspect-sensors
    :parameters (?sensors - sensor-array ?reactor - reactor ?tank - tank)
    :precondition (and
      (sensors-monitor ?sensors ?reactor)
      (tank-serves ?tank ?reactor)
      (not (online ?reactor))
      (not (tank-full ?tank))
      (not (overheated ?reactor))
    )
    :effect (not (sensor-inspection-pending ?sensors))
  )
)

# Planificación automatizada del estado de un reactor nuclear

# Originalidad / Selección de dominio

El dominio seleccionado es el manejo de (un subconjunto de) estados de un reactor nuclear (no realista). Se seleccionó este dominio porque tiene múltiples decisiones no puramente numéricas donde el orden importa y no es siempre intuitivo.

## Proceso de diseño

Dado que se buscaba una solución no trivial, se decidió enfocar el modelo en estados no directamente mutuamente exclusivos. Es decir, las decisiones se pueden tomar en múltiples estados. Por lo tanto, se seleccionaron los siguientes predicados:
- online ?reactor - reactor: Representa el estado activo o inactivo del reactor.
- tank-full ?tank - tank: Representa el estado lleno o vacío del tanque de agua (en este modelo, el agua se trata únicamente como refrigerante, sin considerar que en la práctica también puede actuar como moderador).
- overheated ?reactor - reactor: Representa si el reactor está sobrecalentado o no.
- sensor-inspection-pending ?sensors - sensor-array: Representa si los sensores tienen una inspección pendiente o no.
- tank-serves ?tank - tank ?reactor - reactor: Representa el vínculo entre el tanque y el reactor. En este modelo no cambia de estado.
- sensors-monitor ?sensors - sensor-array ?reactor - reactor: Representa el vínculo entre los sensores y el reactor. En este modelo no cambia de estado.

Y las siguientes acciones:
- take-offline: Desactiva el reactor. Solo puede usarse si el reactor está activo y no está sobrecalentado.
- turn-online: Activa el reactor. Solo puede usarse si el reactor está inactivo y no está sobrecalentado. Tiene un efecto condicional por el cual, si el tanque está vacío, el reactor se sobrecalentará y los sensores necesitarán una inspección.
- drain-tank: Vacía el agua del tanque. Solo puede usarse si el tanque está lleno y el reactor no está sobrecalentado. Tiene un efecto condicional por el cual, si el reactor está activo, se sobrecalentará y los sensores necesitarán una inspección.
- add-water: Llena el tanque de agua y enfría el reactor. Solo puede usarse si el tanque está vacío.
- inspect-sensors: Inspecciona los sensores. Solo puede usarse si el tanque está vacío y el reactor está desactivado y no está sobrecalentado.

Lo interesante del dominio es que algunas acciones provocan efectos secundarios y otras pueden ejecutarse múltiples veces sin provocar cambios. Por ejemplo, en el estado inicial del problema del repositorio, el reactor está activo y sobrecalentado, el tanque está vacío y los sensores tienen una revisión pendiente. En el primer paso, la única acción posible es llenar el tanque, lo que enfría el reactor. En este punto, las condiciones del problema están casi cumplidas, con el reactor activo y sin sobrecalentamiento. Sin embargo, los sensores aún necesitan una revisión, y eso solo se puede hacer con el tanque vacío y el reactor desactivado. Así que, contraintuitivamente, el planificador tiene que desactivar el reactor y luego vaciar el tanque (en ese orden, porque si se vaciara primero, el reactor se volvería a sobrecalentar), lo que lo aleja temporalmente de la meta.

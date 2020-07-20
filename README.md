# bsl_in_cd3

**Контекстная подсказка в 1С КД3**

Выражаю благодарность [salexdv](https://github.com/salexdv) с его разработкой [bsl_console](https://github.com/salexdv/bsl_console) как первому разработчику адаптировавшему редактор VAEditor для работы с кодом 1С.

Данный проект попытка посмотреть на удобство работы с контекстной подсказкой в конфигурации 1С Конвертация данных 3. По моему мнению, даже в ограниченном варианте работать удобнее.

Как подключить:

- Собрать расширение загрузив из исходных файлов в подкаталоге src
- Подключить расширение в КД3
- Загрузить метаданные конфигурации в КД3 типовым способом

Как работает:

- На страницах обработчиков появляется поле "Конфигурация контекстной подсказки" в котором можно выбрать нужную конфигурацию
- Поля обработчиков заменяются на поля HTML документов с работающей подсказкой
- Для подсказки метаданных используются загруженные в 1С метаданные в справочниках "Объекты", "Свойства", "Значения"

Замечания:

- сейчас сдалано на основе синхронных вызовов работы с файлами поэтому проверялось на тонком клиенте, 1С 8.3.16.1063.
- во время работы в каталоге временных файлов создаются файлы в подкаталоге "bsl_console", которые удаляются по окончании работы в 1С

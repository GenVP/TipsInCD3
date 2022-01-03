﻿Функция КонфигурацияОбъекта(ОбъектКонфигурации) Экспорт
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектКонфигурации, "Владелец");
КонецФункции

Процедура ЗаполнитьКонфигурации(ДоступныеКонфигурации, СписокКонвертаций, ЭтоКонвертацияXDTO, ОбъектИсточника, ОбъектПриемника) Экспорт
	КД3_Метаданные.ЗаполнитьКонфигурации(ДоступныеКонфигурации, СписокКонвертаций, ЭтоКонвертацияXDTO, ОбъектИсточника, ОбъектПриемника);
КонецПроцедуры

Процедура ПолучитьВхожденияВКонвертацииДляЭлементаКонвертации(ЭлементКонвертации, СписокКонвертаций, ВедущаяКонфигурация = Неопределено) Экспорт
	КонвертацияДанныхXDTOВызовСервера.ПолучитьВхожденияВКонвертацииДляЭлементаКонвертации(ЭлементКонвертации, СписокКонвертаций, ВедущаяКонфигурация);
КонецПроцедуры
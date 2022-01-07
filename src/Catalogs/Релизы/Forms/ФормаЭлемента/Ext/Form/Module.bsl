﻿
&НаСервере
Процедура КД3_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	Если КД3_Настройки.ИспользоватьКонтекстнуюПодсказку() Тогда
		КД3_ЗаполнитьМестоХраненияИндексов(ЭтотОбъект);
		
		НастройкиКонфигурации = КД3_Метаданные.НастройкиКонфигурации(Объект.Ссылка);
		КД3_МестоХраненияИндексов = НастройкиКонфигурации.МестоХраненияИндексов;
		КД3_КаталогИндексов = НастройкиКонфигурации.КаталогИндексов;
		КД3_ЗагружатьМетодыМодулей = НастройкиКонфигурации.ЗагружатьМетодыМодулей;
		
		Элементы.КД3_КаталогИндексов.Видимость = КД3_МестоХраненияИндексов = 1;
		Элементы.КД3_ЗагружатьМетодыМодулей.Видимость = КД3_МестоХраненияИндексов <> 0;
	Иначе
		Элементы.КД3_ГруппаКонтекстнаяПодсказка.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура КД3_ПослеЗаписиНаСервереПосле(ТекущийОбъект, ПараметрыЗаписи)
	
	Если КД3_Настройки.ИспользоватьКонтекстнуюПодсказку() Тогда
		НастройкиКонфигурации = КД3_Метаданные.НастройкиКонфигурации(ТекущийОбъект.Ссылка);
		Если НастройкиКонфигурации.МестоХраненияИндексов <> КД3_МестоХраненияИндексов Тогда
			КД3_Метаданные.УдалитьОписаниеМетаданных(ТекущийОбъект.Ссылка, НастройкиКонфигурации);
		КонецЕсли;
		
		ИспользоватьПодсказкуДляКонфигурации = КД3_МестоХраненияИндексов <> 0;
		НастройкиКонфигурации.МестоХраненияИндексов = КД3_МестоХраненияИндексов;
		НастройкиКонфигурации.КаталогИндексов = ?(ИспользоватьПодсказкуДляКонфигурации, КД3_КаталогИндексов, "");
		НастройкиКонфигурации.ЗагружатьМетодыМодулей = ИспользоватьПодсказкуДляКонфигурации И КД3_ЗагружатьМетодыМодулей;
		НастройкиКонфигурации.ЗагружатьИзФайлов = Объект.ОбновлятьМетаданныеПоРасписанию И НЕ ПустаяСтрока(Объект.КаталогЗагрузки);
		КД3_Метаданные.ИзменитьНастройкиКонфигурации(ТекущийОбъект.Ссылка, НастройкиКонфигурации);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КД3_ПослеЗаписиПосле(ПараметрыЗаписи)
	Если КД3_НастройкиКлиент.ИспользоватьКонтекстнуюПодсказку() Тогда
		КД3_МетаданныеКлиент.СброситьНастройкиКонфигурацииВКэше(Объект.Ссылка);
		КД3_МетаданныеКлиент.СброситьОписаниеМетаданныхВКэше(Объект.Ссылка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КД3_МестоХранениеИндексовПриИзмененииПосле(Элемент)
	Элементы.КД3_КаталогИндексов.Видимость = КД3_МестоХраненияИндексов = 1;
	Элементы.КД3_ЗагружатьМетодыМодулей.Видимость = КД3_МестоХраненияИндексов <> 0;
КонецПроцедуры

&НаКлиенте
Процедура КД3_ОбновлятьМетаданныеПоРасписаниюПриИзмененииПосле(Элемент)
	
	КД3_ЗаполнитьМестоХраненияИндексов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура КД3_ЗаполнитьМестоХраненияИндексов(Форма)
	
	СписокВыбора = Форма.Элементы.КД3_МестоХраненияИндексов.СписокВыбора;
	
	СписокВыбора.Очистить();
	СписокВыбора.Добавить(0, "Не использовать");
	СписокВыбора.Добавить(1, "В каталоге");
	СписокВыбора.Добавить(2, "В информационной базе");
	Если Форма.Объект.ОбновлятьМетаданныеПоРасписанию Тогда
		СписокВыбора.Добавить(3, "Не хранить");
	КонецЕсли;
	
	Если СписокВыбора.НайтиПоЗначению(Форма.КД3_МестоХраненияИндексов) = Неопределено Тогда
		Форма.КД3_МестоХраненияИндексов = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КД3_ЗагрузитСтруктуруКонфигурацииПосле(Команда)
	
	СтруктураПараметров = Новый Структура("парКонфигурация", Объект.Ссылка);
	СтруктураПараметров.Вставить("ИсточникДанных", Объект.ИсточникДанных);
	СтруктураПараметров.Вставить("КаталогЗагрузки", Объект.КаталогЗагрузки);
	СтруктураПараметров.Вставить("ЕстьРасширения", Объект.ЕстьРасширения);
	СтруктураПараметров.Вставить("ВариантЗагрузкиДвижений", Объект.ВариантЗагрузкиДвижений);
	
	Если Объект.ЕстьРасширения Тогда
		КаталогиРасширений = Новый Массив;
		Для Каждого СтрРасширения Из Объект.Расширения Цикл
			КаталогиРасширений.Добавить(СтрРасширения.ИмяКаталогаЗагрузки);
		КонецЦикла;
		СтруктураПараметров.Вставить("Расширения", КаталогиРасширений);
	КонецЕсли;
	ИмяФормыЗагрузки = "Обработка.КД3_ЗагрузкаСтруктурыКонфигурацииИзФайловXML.Форма";
	ОткрытьФорму(ИмяФормыЗагрузки, СтруктураПараметров);
	
КонецПроцедуры

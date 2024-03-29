﻿
//@skip-warning
&НаСервере
Процедура КД3_Подключаемый_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	ПриСозданииНаСервере(Отказ, СтандартнаяОбработка); //Типовой
	
	Если НЕ КД3_Настройки.ИспользоватьКонтекстнуюПодсказку() Тогда
		Элементы.КД3_ГруппаКонтекстнаяПодсказка.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	КД3_ДобавитьРеквизитыЭлементыФормы();
	
	УстановитьДействие("ПослеЗаписиНаСервере", "КД3_Подключаемый_ПослеЗаписиНаСервереПосле");
	УстановитьДействие("ПослеЗаписи", "КД3_Подключаемый_ПослеЗаписиПосле");
	Элементы.ОбновлятьМетаданныеПоРасписанию.УстановитьДействие("ПриИзменении", "КД3_Подключаемый_ОбновлятьМетаданныеПоРасписаниюПриИзмененииПосле");
	
	КД3_ЗаполнитьМестоХраненияИндексов(ЭтотОбъект);
	
	НастройкиКонфигурации = КД3_Метаданные.НастройкиКонфигурации(Объект.Ссылка);
	ЭтотОбъект.КД3_МестоХраненияИндексов = НастройкиКонфигурации.МестоХраненияИндексов;
	ЭтотОбъект.КД3_КаталогИндексов = НастройкиКонфигурации.КаталогИндексов;
	ЭтотОбъект.КД3_ЗагружатьМетодыМодулей = НастройкиКонфигурации.ЗагружатьМетодыМодулей;
	
	Элементы.КД3_КаталогИндексов.Видимость = ЭтотОбъект.КД3_МестоХраненияИндексов = 1;
	Элементы.КД3_ЗагружатьМетодыМодулей.Видимость = ЭтотОбъект.КД3_МестоХраненияИндексов <> 0;
	
КонецПроцедуры

&НаСервере
Процедура КД3_Подключаемый_ПослеЗаписиНаСервереПосле(ТекущийОбъект, ПараметрыЗаписи)
	
	Если КД3_Настройки.ИспользоватьКонтекстнуюПодсказку() Тогда
		НастройкиКонфигурации = КД3_Метаданные.НастройкиКонфигурации(ТекущийОбъект.Ссылка);
		Если НастройкиКонфигурации.МестоХраненияИндексов <> ЭтотОбъект.КД3_МестоХраненияИндексов Тогда
			КД3_Метаданные.УдалитьОписаниеМетаданных(ТекущийОбъект.Ссылка, НастройкиКонфигурации);
		КонецЕсли;
		
		ИспользоватьПодсказкуДляКонфигурации = ЭтотОбъект.КД3_МестоХраненияИндексов <> 0;
		НастройкиКонфигурации.МестоХраненияИндексов = ЭтотОбъект.КД3_МестоХраненияИндексов;
		НастройкиКонфигурации.КаталогИндексов = ?(ИспользоватьПодсказкуДляКонфигурации, ЭтотОбъект.КД3_КаталогИндексов, "");
		НастройкиКонфигурации.ЗагружатьМетодыМодулей = ИспользоватьПодсказкуДляКонфигурации И ЭтотОбъект.КД3_ЗагружатьМетодыМодулей;
		НастройкиКонфигурации.ЗагружатьИзФайлов = Объект.ОбновлятьМетаданныеПоРасписанию И НЕ ПустаяСтрока(Объект.КаталогЗагрузки);
		КД3_Метаданные.ИзменитьНастройкиКонфигурации(ТекущийОбъект.Ссылка, НастройкиКонфигурации);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_ПослеЗаписиПосле(ПараметрыЗаписи)
	
	Если КД3_НастройкиКлиент.ИспользоватьКонтекстнуюПодсказку() Тогда
		КД3_МетаданныеКлиент.СброситьНастройкиКонфигурацииВКэше(Объект.Ссылка);
		КД3_МетаданныеКлиент.СброситьОписаниеМетаданныхВКэше(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_МестоХранениеИндексовПриИзменении(Элемент)
	
	Элементы.КД3_КаталогИндексов.Видимость = ЭтотОбъект.КД3_МестоХраненияИндексов = 1;
	Элементы.КД3_ЗагружатьМетодыМодулей.Видимость = ЭтотОбъект.КД3_МестоХраненияИндексов <> 0;
	
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_ОбновлятьМетаданныеПоРасписаниюПриИзмененииПосле(Элемент)
	
	ОбновлятьМетаданныеПоРасписаниюПриИзменении(Элемент); // Типовой
	
	КД3_ЗаполнитьМестоХраненияИндексов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_КаталогИндексовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Оповещение = Новый ОписаниеОповещения("КД3_Подключаемый_КаталогИндексовЗавершениеВыбора", ЭтотОбъект);
	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогВыбора.Показать(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_КаталогИндексовЗавершениеВыбора(Результат, ДопПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		ЭтотОбъект.КД3_КаталогИндексов = Результат[0];
	КонецЕсли;
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура КД3_Подключаемый_ЗагрузитСтруктуруКонфигурации(Команда)
	
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
	ИмяФормыЗагрузки = "Обработка.КД3_ЗагрузкаСтруктурыКонфигурацииИзФайловXMLМногопоточно.Форма";
	ОткрытьФорму(ИмяФормыЗагрузки, СтруктураПараметров);
	
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

&НаСервере
Процедура КД3_ДобавитьРеквизитыЭлементыФормы()
	
	ДобавляемыРеквизиты = Новый Массив;
	ДобавляемыРеквизиты.Добавить(Новый РеквизитФормы("КД3_ЗагружатьМетодыМодулей", Новый ОписаниеТипов("Булево")));
	ДобавляемыРеквизиты.Добавить(Новый РеквизитФормы("КД3_КаталогИндексов", Новый ОписаниеТипов("Строка")));
	ДобавляемыРеквизиты.Добавить(Новый РеквизитФормы("КД3_МестоХраненияИндексов", Новый ОписаниеТипов("Число")));
	
	ИзменитьРеквизиты(ДобавляемыРеквизиты, Новый Массив);
	
	ЭлементГруппа = Элементы.Вставить("КД3_ГруппаКонтекстнаяПодсказка", Тип("ГруппаФормы"), ЭтотОбъект, Элементы.Комментарий);
	ЭлементГруппа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	ЭлементГруппа.Заголовок = "Контекстная подсказка (КД3):";
	ЭлементГруппа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	ЭлементГруппа.Отображение = ОтображениеОбычнойГруппы.Нет;
	
	Элемент = Элементы.Добавить("КД3_МестоХраненияИндексов", Тип("ПолеФормы"), ЭлементГруппа);
	Элемент.Вид = ВидПоляФормы.ПолеПереключателя;
	Элемент.ПутьКДанным = "КД3_МестоХраненияИндексов";
	Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
	Элемент.ВидПереключателя = ВидПереключателя.Тумблер;
	Элемент.Заголовок = "Место хранения контекстной подсказки";
	Элемент.Подсказка =
		"Место хранения дополнительных метаданных (отчеты, обработки, общие модули)
		|Не хранить - заполнять в момент использования по исходникам
		|В каталоге - сохраняются в выбранном каталоге
		|В информационной базе - сохраняются в РС ""Хранилище безопасных данных""";
	Элемент.УстановитьДействие("ПриИзменении", "КД3_Подключаемый_МестоХранениеИндексовПриИзменении");
	
	Элемент = Элементы.Добавить("КД3_КаталогИндексов", Тип("ПолеФормы"), ЭлементГруппа);
	Элемент.Вид = ВидПоляФормы.ПолеВвода;
	Элемент.ПутьКДанным = "КД3_КаталогИндексов";
	Элемент.Заголовок = "Каталог индексов метаданных";
	Элемент.КнопкаВыбора = Истина;
	Элемент.Подсказка =
		"Каталог, в который сохраняются индексные файлы дополнительных метаданных.
		|Для клиент-серверной базы должен быть доступен на сервере.";
	Элемент.УстановитьДействие("НачалоВыбора", "КД3_Подключаемый_КаталогИндексовНачалоВыбора");
	
	Элемент = Элементы.Добавить("КД3_ЗагружатьМетодыМодулей", Тип("ПолеФормы"), ЭлементГруппа);
	Элемент.Вид = ВидПоляФормы.ПолеФлажка;
	Элемент.ПутьКДанным = "КД3_ЗагружатьМетодыМодулей";
	Элемент.Заголовок = "Подсказка по процедурам/функциям модулей";
	Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
	
	Команда = Команды.Добавить("КД3_ЗагрузитСтруктуруКонфигурации");
	Команда.Заголовок = "Загрузить структуру конфигурации (КД3)";
	Команда.Действие = "КД3_Подключаемый_ЗагрузитСтруктуруКонфигурации";
	
	ЭлементКоманды = Элементы.Добавить("КД3_ЗагрузитСтруктуруКонфигурации", Тип("КнопкаФормы"), КоманднаяПанель);
	ЭлементКоманды.ИмяКоманды = "КД3_ЗагрузитСтруктуруКонфигурации";
	
КонецПроцедуры

#Если Сервер Тогда
КД3_УправлениеФормой.ПриПервомОткрытииФормы(ЭтотОбъект);
#КонецЕсли

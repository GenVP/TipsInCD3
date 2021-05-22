﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Настройки = КД3_Метаданные.ЗагрузитьНастройки();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Настройки);
	Элементы.ГруппаНастройки.Доступность = ИспользоватьРедакторКода;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьИнформациюПоКонсолиКода();
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Настройки = ЗаписатьНастройкиНаСервере();
	КД3_МетаданныеКлиент.СохранитьНастройкиВКэше(Настройки);
	Закрыть();
	
КонецПроцедуры

&НаСервере
Функция ЗаписатьНастройкиНаСервере()
	
	Настройки = КД3_Метаданные.НастройкиПоУмолчанию();
	ЗаполнитьЗначенияСвойств(Настройки, ЭтотОбъект);
	КД3_Метаданные.СохранитьНастройки(Настройки);
	Возврат Настройки;
	
КонецФункции

&НаКлиенте
Процедура ИспользоватьРедакторКодаПриИзменении(Элемент)
	Если НЕ ИспользоватьРедакторКода Тогда
		ИспользоватьКонтекстнуюПодсказку = Ложь;
	КонецЕсли;
	Элементы.ГруппаНастройки.Доступность = ИспользоватьРедакторКода;
КонецПроцедуры

&НаКлиенте
Процедура КаталогИсходниковНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияКлиент.ОткрытьПроводник(КаталогИсходников);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКонсольКодаИзМакета(Команда)
	КД3_Метаданные.УстановитьФайлМакетаИсходников(Неопределено);
	КД3_МетаданныеКлиент.УдалитьИсходники();
	ОбновитьИнформациюПоКонсолиКода();
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКонсольКодаИзФайла(Команда)
	
	НастройкиДиалога = Новый Структура;
	НастройкиДиалога.Вставить("Фильтр", НСтр("ru = 'Файл архива zip (*.zip)'") + "|*.zip" );
	НастройкиДиалога.Вставить("Заголовок", НСтр("ru='Выберите файл с архивим исходников'"));
	
	Оповещение = Новый ОписаниеОповещения("ЗагрузитьКонсольКодаИзФайлаЗавершение", ЭтотОбъект);
	МодульОбменДаннымиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбменДаннымиКлиент");
	МодульОбменДаннымиКлиент.ВыбратьИПередатьФайлНаСервер(Оповещение, НастройкиДиалога, УникальныйИдентификатор);

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКонсольКодаИзФайлаЗавершение(РезультатПомещенияФайлов, ДопПараметры) Экспорт
	
	АдресФайлаЗагрузки = РезультатПомещенияФайлов.Хранение;
	ТекстОшибки = РезультатПомещенияФайлов.ОписаниеОшибки;
	
	Если ПустаяСтрока(ТекстОшибки) И ПустаяСтрока(АдресФайлаЗагрузки) Тогда
		ТекстОшибки = НСтр("ru = 'Ошибка передачи файла структуры конфигурации на сервер'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки, , "Объект.ИмяФайлаЗагрузки");
	КонецЕсли;
	
	КД3_Метаданные.УстановитьФайлМакетаИсходников(АдресФайлаЗагрузки);
	КД3_МетаданныеКлиент.УдалитьИсходники();
	ОбновитьИнформациюПоКонсолиКода();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформациюПоКонсолиКода()
	КД3_МетаданныеКлиент.ИзвлечьИсходники();
	КаталогИсходников = КД3_Кэш()["КаталогИсходников"];
	Элементы.КонсольКодаИнформация.Заголовок = КД3_Кэш()["КонсольКодаИнформация"];
КонецПроцедуры

﻿Процедура ПодготовитьФайлыДляЗагрузки(ПараметрыЗагрузки) Экспорт
	
	ПараметрыЗагрузки.Вставить("ПомещенныеФайлы", Новый Массив);
	ПараметрыЗагрузки.Вставить("ЭтоРасширение", Ложь);
	
	АдресХранилищаРезультата = "";
	
	ФайлыДляОбработки = Новый Массив;
	Если ПараметрыЗагрузки.ИсточникДанных = 0 Тогда
		ФайлСведений = НайтиФайлы(ПараметрыЗагрузки.КаталогЗагрузки,"Configuration.xml",Ложь);
		ТекстСообщенияОбОшибке = НСтр("ru='В каталоге не найден файл Configuration.xml'");
	Иначе
		ФайлСведений = НайтиФайлы(ПараметрыЗагрузки.КаталогЗагрузки,".project",Ложь);
		ТекстСообщенияОбОшибке = НСтр("ru='В каталоге не найден файл project'");
	КонецЕсли;
	Если ФайлСведений.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщенияОбОшибке);
		Возврат;
	КонецЕсли;
	ДобавитьФайлДляОбработки(ПараметрыЗагрузки, ФайлСведений[0].ПолноеИмя);
	
	ИтерацияПодготовкиФайлов(ПараметрыЗагрузки, ПараметрыЗагрузки.КаталогЗагрузки, ФайлыДляОбработки);
	
	Если ПараметрыЗагрузки.ЕстьРасширения Тогда
		ПараметрыЗагрузки.ЭтоРасширение = Истина;
		Для Каждого ИмяКаталогаРасширения Из ПараметрыЗагрузки.КаталогиРасширений Цикл
			Если НЕ ЗначениеЗаполнено(ИмяКаталогаРасширения) Тогда
				Продолжить;
			КонецЕсли;
			ФайлыДляОбработки = Новый Массив;
			ИтерацияПодготовкиФайлов(ПараметрыЗагрузки, ИмяКаталогаРасширения, ФайлыДляОбработки);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Функция ИтерацияПодготовкиФайлов(ПараметрыЗагрузки, КаталогЗагрузки, ФайлыДляОбработки)
	
	КаталогиДляОбработки = Новый Массив;
	Если ПараметрыЗагрузки.ТолькоОбновитьПланыОбмена Тогда
		КаталогиДляОбработки.Добавить("ExchangePlans");
	Иначе
		КаталогиДляОбработки.Добавить("Catalogs");
		КаталогиДляОбработки.Добавить("Documents");
		КаталогиДляОбработки.Добавить("Enums");
		КаталогиДляОбработки.Добавить("Tasks");
		КаталогиДляОбработки.Добавить("BusinessProcesses");
		КаталогиДляОбработки.Добавить("ChartsOfAccounts");
		КаталогиДляОбработки.Добавить("ChartsOfCalculationTypes");
		КаталогиДляОбработки.Добавить("ChartsOfCharacteristicTypes");
		КаталогиДляОбработки.Добавить("AccountingRegisters");
		КаталогиДляОбработки.Добавить("AccumulationRegisters");
		КаталогиДляОбработки.Добавить("CalculationRegisters");
		КаталогиДляОбработки.Добавить("InformationRegisters");
		КаталогиДляОбработки.Добавить("ExchangePlans");
		КаталогиДляОбработки.Добавить("EventSubscriptions");
		КаталогиДляОбработки.Добавить("Constants");
		КаталогиДляОбработки.Добавить("DefinedTypes");
	КонецЕсли;
	//+КД3
	Если ПараметрыЗагрузки.КД3_ИспользоватьКонтекстнуюПодсказку Тогда
		КаталогиДляОбработки.Добавить("CommonModules");
		//КаталогиДляОбработки.Добавить("Reports");
		//КаталогиДляОбработки.Добавить("DataProcessors");
	КонецЕсли;
	//-КД3
	
	Для Каждого ИмяКаталога Из КаталогиДляОбработки Цикл
		ДобавитьКаталогДляОбработки(ПараметрыЗагрузки, КаталогЗагрузки, ИмяКаталога)
	КонецЦикла;
	
	Если НЕ ПараметрыЗагрузки.ТолькоОбновитьПланыОбмена Тогда
		Если ПараметрыЗагрузки.ИсточникДанных = 0 Тогда
			ВложенныеФайлы = НайтиФайлы(КаталогЗагрузки + "/Constants","*.xml",Ложь);
		Иначе
			ВложенныеФайлы = НайтиФайлы(КаталогЗагрузки + "/src/Constants","*.mdo",Истина);
		КонецЕсли;
		Для Каждого ВложенныйФайл Из ВложенныеФайлы Цикл
			Если ВложенныйФайл.ЭтоКаталог() Тогда
				Продолжить;
			КонецЕсли;
			ДобавитьФайлДляОбработки(ПараметрыЗагрузки, ВложенныйФайл.ПолноеИмя);
		КонецЦикла;
	КонецЕсли;
	
	// Помещение подготовленных файлов во временное храненилище
	Если НЕ ПараметрыЗагрузки.КД3_ЭтоСервер Тогда
		Для Каждого ПомещенныйФайл Из ПараметрыЗагрузки.ПомещенныеФайлы Цикл
			ПомещенныйФайл.Хранение = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ПомещенныйФайл.ПолноеИмя), ПараметрыЗагрузки.УникальныйИдентификатор);
		КонецЦикла;
	КонецЕсли;

КонецФункции

Процедура ДобавитьКаталогДляОбработки(ПараметрыЗагрузки, КаталогЗагрузки, ИмяКаталога) Экспорт
	
	Если ПараметрыЗагрузки.ИсточникДанных = 0 Тогда
		ВложенныеФайлы = НайтиФайлы(КаталогЗагрузки + "\" + ИмяКаталога,"*.xml",Ложь);
	Иначе
		ВложенныеФайлы = НайтиФайлы(КаталогЗагрузки + "\src\" + ИмяКаталога,"*.mdo",Истина);
	КонецЕсли;
	Если ВложенныеФайлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ВложенныйФайл Из ВложенныеФайлы Цикл
		Если ВложенныйФайл.ЭтоКаталог() Тогда
			Продолжить;
		КонецЕсли;
		ДобавитьФайлДляОбработки(ПараметрыЗагрузки, ВложенныйФайл.ПолноеИмя);
		Если ПараметрыЗагрузки.ИсточникДанных = 0 Тогда
			// Предопределенные могут быть в отдельном файле.
			ПутьКПодчиненным = ВложенныйФайл.Путь + ВложенныйФайл.ИмяБезРасширения;
			ФайлСПредопределенными = НайтиФайлы(ПутьКПодчиненным + "\Ext", "Predefined.xml", Ложь);
			Если ФайлСПредопределенными.Количество() > 0 Тогда
				ДобавитьФайлДляОбработки(ПараметрыЗагрузки, ФайлСПредопределенными[0].ПолноеИмя);
			КонецЕсли;
			// Состав плана обмена
			Если ИмяКаталога = "ExchangePlans" Тогда
				ФайлССоставом = НайтиФайлы(ПутьКПодчиненным + "\Ext", "Content.xml", Ложь);
				Если ФайлССоставом.Количество() > 0 Тогда
					ДобавитьФайлДляОбработки(ПараметрыЗагрузки, ФайлССоставом[0].ПолноеИмя);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		//+КД3
		Если ПараметрыЗагрузки.КД3_ИспользоватьКонтекстнуюПодсказку Тогда
			Если ПараметрыЗагрузки.КД3_ЗагружатьМетодыГлобальныхМодулей ИЛИ ПараметрыЗагрузки.КД3_ЗагружатьМетодыМодулей Тогда
				Если ПараметрыЗагрузки.ИсточникДанных = 0 Тогда
					ПутьКПодчиненным = ВложенныйФайл.Путь + ВложенныйФайл.ИмяБезРасширения + "\Ext";
				Иначе
					ПутьКПодчиненным = ВложенныйФайл.Путь;
				КонецЕсли;
				ФайлыСМодулем = НайтиФайлы(ПутьКПодчиненным, "*.bsl", Ложь);
				Для Каждого ФайлСМодулем Из ФайлыСМодулем Цикл
					ДобавитьФайлДляОбработки(ПараметрыЗагрузки, ФайлСМодулем.ПолноеИмя);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		//-КД3
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьФайлДляОбработки(ПараметрыЗагрузки, ПолноеИмяФайла)
	
	ПараметрыЗагрузки.ПомещенныеФайлы.Добавить(Новый Структура("ПолноеИмя, Хранение, ЭтоРасширение",
		ПолноеИмяФайла, ?(ПараметрыЗагрузки.КД3_ЭтоСервер, ПолноеИмяФайла, Неопределено), ПараметрыЗагрузки.ЭтоРасширение));
	
КонецПроцедуры


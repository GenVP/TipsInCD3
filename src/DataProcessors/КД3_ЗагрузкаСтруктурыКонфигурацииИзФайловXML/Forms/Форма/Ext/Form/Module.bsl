﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Объект.ВариантЗагрузкиДвижений = 1;
	Если Параметры.Свойство("парКонфигурация") И ЗначениеЗаполнено(Параметры.парКонфигурация) Тогда
		Объект.Конфигурация = Параметры.ПарКонфигурация;
		СпособЗагрузки = 1;
		Если Параметры.Свойство("ИсточникДанных") Тогда
			Объект.ИсточникДанных = Параметры.ИсточникДанных;
		КонецЕсли;
		Если Параметры.Свойство("КаталогЗагрузки") Тогда
			Объект.ИмяКаталогаЗагрузки = Параметры.КаталогЗагрузки;
		КонецЕсли;
		Если Параметры.Свойство("ВариантЗагрузкиДвижений") Тогда
			Объект.ВариантЗагрузкиДвижений = Параметры.ВариантЗагрузкиДвижений;
		КонецЕсли;

		Если Параметры.Свойство("ЕстьРасширения") Тогда
			Объект.ЕстьРасширения = Параметры.ЕстьРасширения;
			Если Параметры.ЕстьРасширения И Параметры.Свойство("Расширения") Тогда
				Для Каждого ИмяКаталога Из Параметры.Расширения Цикл
					НовСтрока = Объект.Расширения.Добавить();
					НовСтрока.ИмяКаталогаЗагрузки = ИмяКаталога;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ЗначениеЗаполнено(Объект.Конфигурация) Тогда
		СпособЗагрузки = 1;
	КонецЕсли;
	
	УстановитьВидимость();
	//+КД3
	КД3_ИзменитьРежимОбработки();
	//-КД3
КонецПроцедуры
#КонецОбласти
#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИмяКаталогаЗагрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Оповещение = Новый ОписаниеОповещения("ЗавершениеВыбораКаталога", ЭтотОбъект, Новый Структура("ВыборРасширения", Ложь));
	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Если ЗначениеЗаполнено(Объект.ИмяКаталогаЗагрузки) Тогда
		ДиалогВыбора.Каталог = Объект.ИмяКаталогаЗагрузки;
	КонецЕсли;
	ДиалогВыбора.Показать(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура РасширенияИмяКаталогаЗагрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Оповещение = Новый ОписаниеОповещения("ЗавершениеВыбораКаталога", ЭтотОбъект, Новый Структура("ВыборРасширения", Истина));
	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ТекКаталог = Элементы.Расширения.ТекущиеДанные.ИмяКаталогаЗагрузки;
	Если ЗначениеЗаполнено(ТекКаталог) Тогда
		ДиалогВыбора.Каталог = ТекКаталог;
	КонецЕсли;
	ДиалогВыбора.Показать(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура СпособЗагрузкиПриИзменении(Элемент)
	Если СпособЗагрузки = 0 Тогда
		Объект.ТолькоДобавлятьНовые = Ложь;
		Объект.ТолькоОбновитьПланыОбмена = Ложь;
	КонецЕсли;
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ЕстьРасширенияПриИзменении(Элемент)
	УстановитьВидимость();
	 
КонецПроцедуры

&НаКлиенте
Процедура КД3_НаКлиенте(Команда)
	
	Если КД3_ЭтоСервер Тогда
		КД3_ЭтоСервер = Ложь;
		КД3_ИзменитьРежимОбработки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КД3_НаСервере(Команда)
	
	Если НЕ КД3_ЭтоСервер Тогда
		КД3_ЭтоСервер = Истина;
		КД3_ИзменитьРежимОбработки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КД3_ИзменитьРежимОбработки()
	
	КоманднаяПанель.ПодчиненныеЭлементы.КД3_РежимРаботы.ПодчиненныеЭлементы.ФормаНаКлиенте.Пометка = НЕ КД3_ЭтоСервер;
	КоманднаяПанель.ПодчиненныеЭлементы.КД3_РежимРаботы.ПодчиненныеЭлементы.ФормаНаСервере.Пометка = КД3_ЭтоСервер;
	
	КоманднаяПанель.ПодчиненныеЭлементы.КД3_РежимРаботы.Заголовок = 
	?(КД3_ЭтоСервер, НСтр("ru = 'Режим работы (на сервере)'"), НСтр("ru = 'Режим работы (на клиенте)'"));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьЗагрузку(Команда)
	Если НЕ ЗначениеЗаполнено(Объект.ИмяКаталогаЗагрузки) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Не выбран каталог со структурой конфигурации'"));
		Возврат;
	КонецЕсли;
	Если СпособЗагрузки = 1 И НЕ ЗначениеЗаполнено(Объект.Конфигурация) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Не выбрана конфигурация для загрузки'"));
		Возврат;
	КонецЕсли;
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.Ожидание;
	ИзменитьДоступностьЭлементовФормы(Ложь);
	ПодготовитьФайлыДляСервераНачало(); 
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПодготовитьФайлыДляСервераНачало()
	АдресХранилищаРезультата = "";
	
	//+КД3
	ПараметрыЗагрузки = Новый Структура;
	ПараметрыЗагрузки.Вставить("ИсточникДанных", Объект.ИсточникДанных);
	ПараметрыЗагрузки.Вставить("КаталогЗагрузки", Объект.ИмяКаталогаЗагрузки);
	ПараметрыЗагрузки.Вставить("ТолькоОбновитьПланыОбмена", Объект.ТолькоОбновитьПланыОбмена);
	ПараметрыЗагрузки.Вставить("КД3_ЗагружатьМетодыМодулей", Ложь);
	ПараметрыЗагрузки.Вставить("КД3_ИспользоватьКонтекстнуюПодсказку", Ложь);
	ПараметрыЗагрузки.Вставить("КД3_ЭтоСервер", КД3_ЭтоСервер);
	ПараметрыЗагрузки.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	
	ПараметрыЗагрузки.Вставить("КаталогиРасширений", Новый Массив);
	Для Каждого СтрокаРасширения Из Объект.Расширения Цикл
		ПараметрыЗагрузки.КаталогиРасширений.Добавить(СтрокаРасширения.ИмяКаталогаЗагрузки);
	КонецЦикла;
	ПараметрыЗагрузки.Вставить("ЕстьРасширения", ПараметрыЗагрузки.КаталогиРасширений.Количество() > 0);
	
	КД3_ЗагрузкаМетаданныхКлиентСервер.ПодготовитьФайлыДляЗагрузки(ПараметрыЗагрузки);
	//-КД3
	
	ВыполнитьЗагрузкуСервер(ПараметрыЗагрузки);
	
	//+КД3
	КД3_ПрогрессТекст0 = "Обработка данных файлов";
	КД3_Прогресс0 = "";
	ПодключитьОбработчикОжидания("ОбработчикОжиданияДлительнойОперации", 5, Истина);
	//-КД3
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияДлительнойОперации()
	Если НЕ ДлительнаяОперация Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.Основная;
		ИзменитьДоступностьЭлементовФормы(Истина);
		Возврат;
	КонецЕсли;
	Если ДлительнаяОперацияВыполнена() Тогда
		ДлительнаяОперация = Ложь;
		ПодключитьОбработчикОжидания("ОкончаниеЗагрузкиКонфигурации", 1, Истина);
	Иначе
		ПодключитьОбработчикОжидания("ОбработчикОжиданияДлительнойОперации", 5, Истина);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ДлительнаяОперацияВыполнена()
	Если ИдентификаторЗадания = Неопределено Тогда
		Возврат Истина;
	КонецЕсли;
	//+КД3
	КД3_ЗагрузкаМетаданных.ОбновитьПрогрессНаФорме(ИдентификаторЗадания, ЭтотОбъект);
	//-КД3
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
КонецФункции

&НаКлиенте
Процедура ОкончаниеЗагрузкиКонфигурации()
	РезультатЗагрузки = ПолучитьИзВременногоХранилища(АдресХранилищаРезультата);
	Если РезультатЗагрузки Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Загрузка структуры конфигурации выполнена успешно'"));
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Загрузка структуры конфигурации не выполнена'"));
	КонецЕсли;
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.Основная;
	ИзменитьДоступностьЭлементовФормы(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьДоступностьЭлементовФормы(ФлагДоступность)
	Элементы.ФормаВыполнитьЗагрузку.Доступность = ФлагДоступность;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость()
	ЗагружатьВКонфигурацию = (СпособЗагрузки = 1);
	Элементы.Конфигурация.Видимость = ЗагружатьВКонфигурацию;
	Элементы.ТолькоДобавлятьНовые.Видимость = ЗагружатьВКонфигурацию;
	Элементы.Расширения.Видимость = Объект.ЕстьРасширения;
	Элементы.ТолькоОбновитьПланыОбмена.Видимость = ЗагружатьВКонфигурацию;
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗагрузкуСервер(ПараметрыЗагрузки)
	ИдентификаторЗадания = Неопределено;
	ДлительнаяОперация = Ложь;
	АдресХранилищаРезультата = "";
	//+КД3
	Если НЕ КД3_ЭтоСервер Тогда
		// Преобразование помещенных файлов
		Для Каждого ПомФайл Из ПараметрыЗагрузки.ПомещенныеФайлы Цикл
			ИмяФайлаСведений = ПолучитьИмяВременногоФайла("xml");
			ДвоичныеДанные = ПолучитьИзВременногоХранилища(ПомФайл.Хранение);
			ДвоичныеДанные.Записать(ИмяФайлаСведений);
			
			УдалитьИзВременногоХранилища(ПомФайл.Хранение);
			ПомФайл.Хранение = ИмяФайлаСведений;
		КонецЦикла;
	КонецЕсли;
	СтруктураПараметров = ПараметрыЗагрузки;
	СтруктураПараметров.Вставить("СпособЗагрузки", СпособЗагрузки);
	СтруктураПараметров.Вставить("Конфигурация", Объект.Конфигурация);
	СтруктураПараметров.Вставить("ВариантЗагрузкиДвижений", Объект.ВариантЗагрузкиДвижений);
	СтруктураПараметров.Вставить("ТолькоДобавлятьНовые", Объект.ТолькоДобавлятьНовые);
	СтруктураПараметров.Вставить("КД3_СообщатьПрогресс");
	СтруктураПараметров.Вставить("КД3_КоличествоПотоков", 1);
	//-КД3
	Попытка
		ПараметрыФоновогоЗадания = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
		ПараметрыФоновогоЗадания.НаименованиеФоновогоЗадания = НСтр("ru = 'Загрузка структуры метаданных из каталога'");
		ПараметрыФоновогоЗадания.ЗапуститьВФоне = Истина;
		Результат = ДлительныеОперации.ВыполнитьВФоне("Обработки.КД3_ЗагрузкаСтруктурыКонфигурацииИзФайловXML.ВыполнитьЗагрузкуМетаданных",
			СтруктураПараметров, ПараметрыФоновогоЗадания);
		АдресХранилищаРезультата = Результат.АдресРезультата;
		Если Результат.Статус = "Выполнено" Тогда
			РезультатЗагрузки = ПолучитьИзВременногоХранилища(АдресХранилищаРезультата);
			Если РезультатЗагрузки Тогда
				ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Загрузка структуры конфигурации выполнена успешно'"));
			Иначе
				ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Загрузка структуры конфигурации не выполнена'"));
			КонецЕсли;
			Попытка
				УдалитьФайлы(ИмяФайлаСведений);
			Исключение
				ИмяФайлаСведений = "";
			КонецПопытки;
		Иначе
			ДлительнаяОперация = Истина;
			ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		КонецЕсли;
	Исключение
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'При загрузке структуры конфигурации произошла ошибка'") + Символы.ПС + ОписаниеОшибки());
		Возврат;
	КонецПопытки
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеВыбораКаталога(Знач ВыбранныеФайлы, Знач ДопПараметры) Экспорт
	Если ВыбранныеФайлы = Неопределено Или НЕ ДопПараметры.Свойство("ВыборРасширения") Тогда
		Возврат;
	КонецЕсли;
	Если ДопПараметры.ВыборРасширения Тогда
		НомСтроки = Элементы.Расширения.ТекущиеДанные.НомерСтроки;
		Объект.Расширения[НомСтроки - 1].ИмяКаталогаЗагрузки = ВыбранныеФайлы[0];
	Иначе
		Объект.ИмяКаталогаЗагрузки = ВыбранныеФайлы[0];
	КонецЕсли;
	ОбновитьОтображениеДанных();
КонецПроцедуры

#КонецОбласти

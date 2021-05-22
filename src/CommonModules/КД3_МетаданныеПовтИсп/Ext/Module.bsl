﻿
Функция КорневойТипЗначений(КорневойТип) Экспорт
	
	Возврат КорневойТип = "перечисления" ИЛИ КорневойТип = "справочники"
		ИЛИ КорневойТип = "планысчетов" ИЛИ КорневойТип = "планывидовхарактеристик";
	
КонецФункции

Функция КорневойТипРегистра(КорневойТип) Экспорт
	
	Возврат КорневойТип = "регистрысведений" ИЛИ КорневойТип = "регистрынакопления"
		 ИЛИ КорневойТип = "регистрыбухгалтерии" ИЛИ КорневойТип = "регистрырасчета";
	
КонецФункции

Функция КорневойТипТЧ(КорневойТип) Экспорт
	
	Возврат КорневойТип = "справочники" ИЛИ КорневойТип = "документы"
		 ИЛИ КорневойТип = "отчеты" ИЛИ КорневойТип = "обработки"
		 ИЛИ КорневойТип = "бизнеспроцессы" ИЛИ КорневойТип = "задачи";
	
КонецФункции

Функция ТипОбъектаПоКорневомуТипу(КорневойТип) Экспорт
	
	СоответствиеТипов = Новый Соответствие;
	СоответствиеТипов.Вставить("справочники", Перечисления.ТипыОбъектов.Справочник);
	СоответствиеТипов.Вставить("документы", Перечисления.ТипыОбъектов.Документ);
	СоответствиеТипов.Вставить("регистрысведений", Перечисления.ТипыОбъектов.РегистрСведений);
	СоответствиеТипов.Вставить("регистрынакопления", Перечисления.ТипыОбъектов.РегистрНакопления);
	СоответствиеТипов.Вставить("регистрыбухгалтерии", Перечисления.ТипыОбъектов.РегистрБухгалтерии);
	СоответствиеТипов.Вставить("регистрырасчета", Перечисления.ТипыОбъектов.РегистрРасчета);
	СоответствиеТипов.Вставить("перечисления", Перечисления.ТипыОбъектов.Перечисление);
	СоответствиеТипов.Вставить("планысчетов", Перечисления.ТипыОбъектов.ПланСчетов);
	СоответствиеТипов.Вставить("бизнеспроцессы", Перечисления.ТипыОбъектов.БизнесПроцесс);
	СоответствиеТипов.Вставить("задачи", Перечисления.ТипыОбъектов.Задача);
	СоответствиеТипов.Вставить("планыобмена", Перечисления.ТипыОбъектов.ПланОбмена);
	СоответствиеТипов.Вставить("планывидовхарактеристик", Перечисления.ТипыОбъектов.ПланВидовХарактеристик);
	СоответствиеТипов.Вставить("планывидоврасчета", Перечисления.ТипыОбъектов.ПланВидовРасчета);
	
	Возврат СоответствиеТипов[КорневойТип];
	
КонецФункции

Функция ИмяКоллекцииПоКорневомуТипу(КорневойТип) Экспорт
	
	СоответствиеИмен = Новый Соответствие();
	СоответствиеИмен.Вставить("справочники", "catalogs");
	СоответствиеИмен.Вставить("catalogs", "catalogs");
	СоответствиеИмен.Вставить("документы", "documents");
	СоответствиеИмен.Вставить("documents", "documents");
	СоответствиеИмен.Вставить("регистрысведений", "infoRegs");
	СоответствиеИмен.Вставить("informationregisters", "infoRegs");
	СоответствиеИмен.Вставить("регистрынакопления", "accumRegs");
	СоответствиеИмен.Вставить("accumulationregisters", "accumRegs");
	СоответствиеИмен.Вставить("регистрыбухгалтерии", "accountRegs");
	СоответствиеИмен.Вставить("accountingregisters", "accountRegs");
	СоответствиеИмен.Вставить("регистрырасчета", "calcRegs");
	СоответствиеИмен.Вставить("calculationregisters", "calcRegs");
	СоответствиеИмен.Вставить("обработки", "dataProc");
	СоответствиеИмен.Вставить("dataprocessors", "dataProc");
	СоответствиеИмен.Вставить("отчеты", "reports");
	СоответствиеИмен.Вставить("reports", "reports");
	СоответствиеИмен.Вставить("перечисления", "enums");
	СоответствиеИмен.Вставить("enums", "enums");
	СоответствиеИмен.Вставить("планысчетов", "сhartsOfAccounts");
	СоответствиеИмен.Вставить("chartsofaccounts", "сhartsOfAccounts");
	СоответствиеИмен.Вставить("бизнеспроцессы", "businessProcesses");
	СоответствиеИмен.Вставить("businessprocesses", "businessProcesses");
	СоответствиеИмен.Вставить("задачи", "tasks");
	СоответствиеИмен.Вставить("tasks", "tasks");
	СоответствиеИмен.Вставить("планыобмена", "exchangePlans");
	СоответствиеИмен.Вставить("exchangeplans", "exchangePlans");
	СоответствиеИмен.Вставить("планывидовхарактеристик", "chartsOfCharacteristicTypes");
	СоответствиеИмен.Вставить("chartsofcharacteristictypes", "chartsOfCharacteristicTypes");
	СоответствиеИмен.Вставить("планывидоврасчета", "chartsOfCalculationTypes");
	СоответствиеИмен.Вставить("chartsofcalculationtypes", "chartsOfCalculationTypes");
	СоответствиеИмен.Вставить("константы", "constants");
	СоответствиеИмен.Вставить("constants", "constants");
	
	Возврат СоответствиеИмен[КорневойТип];
	
КонецФункции

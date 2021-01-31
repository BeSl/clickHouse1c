﻿#Область Кнопы
&НаКлиенте
Процедура Команда1(Команда)
	Команда1НаСервере();
КонецПроцедуры

&НаСервере
Процедура Команда1НаСервере()

	ПроверитьПодключениеКБазе(ПараметрыПодключенияПоУмолчанию());
	//СоздатьТаблицуВСУБД(Gfh);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьБД(Команда)
	СоздатьБДНаСервере();
КонецПроцедуры

&НаСервере
Процедура СоздатьБДНаСервере()
	СоздатьБазуДанныхВСУБД(ПараметрыПодключенияПоУмолчанию());
КонецПроцедуры

&НаКлиенте
Процедура СоздатьТаблицу(Команда)
	СоздатьТаблицуНаСервере();
КонецПроцедуры

&НаСервере
Процедура СоздатьТаблицуНаСервере()
	
	СоздатьТаблицуВСУБД(ПараметрыПодключенияПоУмолчанию(), "myTable", "");
КонецПроцедуры

&НаКлиенте
Процедура ТестЗапрос(Команда)
	ТестЗапросНаСервере();
КонецПроцедуры

&НаСервере
Процедура ТестЗапросНаСервере()
	ТестовыйЗапрос(ПараметрыПодключенияПоУмолчанию());
КонецПроцедуры

&НаКлиенте
Процедура ВставитьДанныеВТаблицу(Команда)
	ВставитьДанныеВТаблицуНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВставитьДанныеВТаблицуНаСервере()
	ВставкаДанныхВТаблицу(ПараметрыПодключенияПоУмолчанию());
КонецПроцедуры

&НаКлиенте
Процедура ВыборкаДанных(Команда)
	ВыборкаДанныхНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВыборкаДанныхНаСервере()
	ВыборкаДанныхИЗСУБД(ПараметрыПодключенияПоУмолчанию());
КонецПроцедуры

&НаСервере
Процедура ШаблонЗапросаSelectНаСервере()
	СгенерироватьШаблонЗапросаВыбрать();
КонецПроцедуры

&НаКлиенте
Процедура ШаблонЗапросаSelect(Команда)
	ШаблонЗапросаSelectНаСервере();
КонецПроцедуры


#КонецОбласти

#Область СобытияФормы
#КонецОбласти

#Область СамоВзаимодействие
Процедура СоздатьБазуДанныхВСУБД(ПараметрыПодключения)
	
	ТекстЗапроса = СтрШаблон("CREATE DATABASE %1 ENGINE = MergeTree", ИмяБД);
	Заголовки = Новый Соответствие; 
	Заголовки.Вставить("query", ТекстЗапроса);
	
	ВыполнитьЗапросВБД(Заголовки);
КонецПроцедуры

Процедура ПроверитьПодключениеКБазе(ПараметрыПодключения)
	
	HTTPСоеднинениеВнБД = Новый HTTPСоединение(ПараметрыПодключения.АдресСервера, 
										   ПараметрыПодключения.Порт,
										   ПараметрыПодключения.Логин,
										   ПараметрыПодключения.Пароль);
	КомандаПроверки = "ping";
	HTTPЗапросВнБД = Новый HTTPЗапрос(КомандаПроверки);
	
	HTTPОтветВнБД = HTTPСоеднинениеВнБД.Получить(HTTPЗапросВнБД);
	
	Если HTTPОтветВнБД.КодСостояния = 200 Тогда
		РезультатЗапроса = HTTPОтветВнБД.ПолучитьТелоКакСтроку();
		Сообщить(РезультатЗапроса);
	КонецЕсли;
	
КонецПроцедуры


Процедура СоздатьТаблицуВСУБД(ПараметрыПодключения, ИмяТаблицы, ИзмеренияТаблицы)
	
	СтрокаПараметров = СтрШаблон("CREATE TABLE %1.%2 (id UInt8, demoStroka VARCHAR)", ИмяБД, ОснТаблица);	
	Заголовки = Новый Соответствие; 
	Заголовки.Вставить("query", СтрокаПараметров);
	ВыполнитьЗапросВБД(Заголовки);
	
КонецПроцедуры

Процедура ТестовыйЗапрос(ПараметрыПодключения)
	
	HTTPСоеднинениеВнБД = Новый HTTPСоединение(ПараметрыПодключения.АдресСервера, 
										   ПараметрыПодключения.Порт,
										   ПараметрыПодключения.Логин,
										   ПараметрыПодключения.Пароль);
										   
	
	СтрокаПараметров = "/?query=Select 1";
	HTTPЗапросВнБД = Новый HTTPЗапрос(СтрокаПараметров);
	HTTPОтветВнБД = HTTPСоеднинениеВнБД.Получить(HTTPЗапросВнБД);
	
	РезультатЗапроса = Неопределено;
	//
	//Если HTTPОтветВнБД.КодСостояния = 200 Тогда
	РезультатЗапроса = HTTPОтветВнБД.ПолучитьТелоКакСтроку();
	//КонецЕсли;
	Сообщить("КодСостояния " +HTTPОтветВнБД.КодСостояния);
	Сообщить(РезультатЗапроса);	
КонецПроцедуры

Процедура ВставкаДанныхВТаблицу(ПараметрыПодключения)
	
	СтрокаПараметров = СтрШаблон("INSERT  INTO %3.%4 VALUES(%1, %2);", Реквизит1, Реквизит2, ИмяБД, ОснТаблица);
	//СтрокаПараметров = "INSERT INTO myDB.myTab Values('2021-01-15', '2021-02-21','й\=11s','03ww')";	
	
	ВыполнитьЗапросВБД(СтрокаПараметров, "query");
	
КонецПроцедуры

Процедура ВыборкаДанныхИЗСУБД(ПараметрыПодключения)
	
	ОтветОтБД = ЗапросВыборки("?query=" + ТекстЗапросаВыборки);
	Сообщить(ОтветОтБД);
	
КонецПроцедуры

Процедура СгенерироватьШаблонЗапросаВыбрать()
	
	БазовыйШаблон = "SELECT * FROM %1.%2";
	
	Если ЗначениеЗаполнено(ФорматПринимаемыхДанных) Тогда
		ДобавкаФормата = " FORMAT "+ФорматПринимаемыхДанных;
		БазовыйШаблон = БазовыйШаблон + ДобавкаФормата;
	КонецЕсли;
	
	ТекстЗапросаВыборки = СтрШаблон(БазовыйШаблон, ИмяБД, ОснТаблица);
	
КонецПроцедуры
#КонецОбласти

#Область МетодыПомощники

Функция ПараметрыПодключенияПоУмолчанию()
	
	ПараметрыПодключения = Новый Структура;
	ПараметрыПодключения.Вставить("АдресСервера", "localhost");
	ПараметрыПодключения.Вставить("Порт", 8123);
	ПараметрыПодключения.Вставить("СтрокаЗапроса", "");
	ПараметрыПодключения.Вставить("Логин", "default");
	ПараметрыПодключения.Вставить("Пароль", "");	
	
	Возврат ПараметрыПодключения;
	
КонецФункции

Функция ЗапросВыборки(ТекстЗапроса)
	
	HTTPСоеднинениеВнБД = Новый HTTPСоединение(АдресСервера, 
										   Порт,
										   Логин,
										   Пароль);
										   
	HTTPЗапросВнБД = Новый HTTPЗапрос(ТекстЗапроса);
	HTTPОтветВнБД = HTTPСоеднинениеВнБД.Получить(HTTPЗапросВнБД);
	
	РезультатЗапроса = Неопределено;
	РезультатЗапроса = HTTPОтветВнБД.ПолучитьТелоКакСтроку();
	Сообщить("Код состояния " + HTTPОтветВнБД.КодСостояния);
	Возврат РезультатЗапроса;	
	
	
КонецФункции

Процедура ВыполнитьЗапросВБД(Заголовки, СтрокаПараметров = "")
	
	HTTPСоеднинениеВнБД = Новый HTTPСоединение(АдресСервера, 
										   Порт,
										   Логин,
										   Пароль);
										   
	ЗапросФайлом = ПолучитьИмяВременногоФайла();
	ФайлЗапрос = Новый ТекстовыйДокумент();
	ФайлЗапрос.УстановитьТекст(Заголовки);
	ФайлЗапрос.Записать(ЗапросФайлом, КодировкаТекста.UTF8);
	HTTPЗапросВнБД = Новый HTTPЗапрос();
	HTTPЗапросВнБД.УстановитьИмяФайлаТела(ЗапросФайлом);
	
	HTTPОтветВнБД = HTTPСоеднинениеВнБД.ОтправитьДляОбработки(HTTPЗапросВнБД);
	
	РезультатЗапроса = Неопределено;
	РезультатЗапроса = HTTPОтветВнБД.ПолучитьТелоКакСтроку();
	Сообщить("Код состояния " + HTTPОтветВнБД.КодСостояния);
	Сообщить("Результат " + РезультатЗапроса);	
	
КонецПроцедуры

Функция ВариантыФорматовОтветов()
	
	ФорматыОтветов = Новый Массив;
	ФорматыОтветов.Добавить("TabSeparated");
	ФорматыОтветов.Добавить("TabSeparatedRaw");
ФорматыОтветов.Добавить("TabSeparatedWithNames");
ФорматыОтветов.Добавить("TabSeparatedWithNamesAndTypes");
ФорматыОтветов.Добавить("Template");
ФорматыОтветов.Добавить("CSV");
ФорматыОтветов.Добавить("CSVWithNames");
ФорматыОтветов.Добавить("CustomSeparated");
ФорматыОтветов.Добавить("Values");
ФорматыОтветов.Добавить("Vertical");
ФорматыОтветов.Добавить("VerticalRaw");
ФорматыОтветов.Добавить("JSON");
ФорматыОтветов.Добавить("JSONString");
ФорматыОтветов.Добавить("JSONCompact");
ФорматыОтветов.Добавить("JSONCompactString");
ФорматыОтветов.Добавить("JSONEachRow");
ФорматыОтветов.Добавить("JSONEachRowWithProgress");
ФорматыОтветов.Добавить("JSONStringEachRow");
ФорматыОтветов.Добавить("JSONStringEachRowWithProgress");
ФорматыОтветов.Добавить("JSONCompactEachRow");
ФорматыОтветов.Добавить("JSONCompactEachRowWithNamesAndTypes");
ФорматыОтветов.Добавить("JSONCompactStringEachRow");
ФорматыОтветов.Добавить("JSONCompactStringEachRowWithNamesAndTypes");
ФорматыОтветов.Добавить("TSKV");
ФорматыОтветов.Добавить("Pretty");
ФорматыОтветов.Добавить("PrettyCompact");
ФорматыОтветов.Добавить("PrettyCompactMonoBlock");
ФорматыОтветов.Добавить("PrettyNoEscapes");
ФорматыОтветов.Добавить("PrettySpace");
ФорматыОтветов.Добавить("Protobuf");
ФорматыОтветов.Добавить("ProtobufSingle");
ФорматыОтветов.Добавить("Avro");
ФорматыОтветов.Добавить("Parquet");
ФорматыОтветов.Добавить("Arrow");
ФорматыОтветов.Добавить("ArrowStream");
ФорматыОтветов.Добавить("RowBinary");
ФорматыОтветов.Добавить("RowBinaryWithNamesAndTypes");
ФорматыОтветов.Добавить("Native");
ФорматыОтветов.Добавить("Null");
ФорматыОтветов.Добавить("XML");
ФорматыОтветов.Добавить("RawBLOB");
возврат ФорматыОтветов;	
КонецФункции

#КонецОбласти


#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//К удалению
	ЗаполнитьПараметрыДляТестов();
	
	Элементы.ФорматПринимаемыхДанных.СписокВыбора.ЗагрузитьЗначения(ВариантыФорматовОтветов());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
// Код процедур и функций
#КонецОбласти

//#Область ОбработчикиСобытийЭлементовТаблицыФормы<ИмяТаблицыФормы>
//// Код процедур и функций
//#КонецОбласти

#Область ОбработчикиКомандФормы
// Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Функция ОбработкаОбъект()
	
	Возврат РеквизитФормыВЗначение("Объект");
	
КонецФункции

//
//для разработки
//
&НаСервере
Процедура ЗаполнитьПараметрыДляТестов()
	
	ИмяБД = "myDB";
	ОснТаблица = "testTable";
	ТекстЗапросаВыборки = СтрШаблон("Select * FROM %1.%2 FORMAT JSON", ИмяБД, ОснТаблица);	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, ПараметрыПодключенияПоУмолчанию());
	
КонецПроцедуры
#КонецОбласти
//CREATE DATABASE [IF NOT EXISTS] db_name [ON CLUSTER cluster] 
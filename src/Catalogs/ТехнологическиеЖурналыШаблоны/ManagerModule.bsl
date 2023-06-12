#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Функция ПолучитьШаблонПредопределенного(Ссылка) Экспорт
	Шаблон = Неопределено;
	Если Ссылка.Предопределенный Тогда
		Имя = ИмяПредопределенного(Ссылка);
		Если Имя = "ATTN" Тогда
			Шаблон = ШаблонATTN();
		ИначеЕсли Имя = "CALL" Тогда
			Шаблон = ШаблонCALL();
		ИначеЕсли Имя = "CONN" Тогда
			Шаблон = ШаблонCONN();
		ИначеЕсли Имя = "DataBaseException" Тогда
			Шаблон = ШаблонDataBaseException();
		ИначеЕсли Имя = "DB" Тогда
			Шаблон = ШаблонDB();
		ИначеЕсли Имя = "DUMP" Тогда
			Шаблон = ШаблонDUMP();
		ИначеЕсли Имя = "EXCP" Тогда
			Шаблон = ШаблонEXCP();
		ИначеЕсли Имя = "PROC" Тогда
			Шаблон = ШаблонPROC();
		ИначеЕсли Имя = "RetExcp" Тогда
			Шаблон = ШаблонRetExcp();
		ИначеЕсли Имя = "SDBL" Тогда
			Шаблон = ШаблонSDBL();
		ИначеЕсли Имя = "SESN" Тогда
			Шаблон = ШаблонSESN();
		ИначеЕсли Имя = "TDEADLOCK" Тогда
			Шаблон = ШаблонTDEADLOCK();
		ИначеЕсли Имя = "TLOCK" Тогда
			Шаблон = ШаблонTLOCK();
		КонецЕсли;
	КонецЕсли;	
	
	Возврат Шаблон;
КонецФункции

Функция ПолучитьПредопределеныеНастройки() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ТехнологическиеЖурналыШаблоны.Шаблон КАК Шаблон
	|ИЗ
	|	Справочник.ТехнологическиеЖурналыШаблоны КАК ТехнологическиеЖурналыШаблоны
	|ГДЕ
	|	ТехнологическиеЖурналыШаблоны.Предопределенный = ИСТИНА
	|УПОРЯДОЧИТЬ ПО
	|	ТехнологическиеЖурналыШаблоны.Наименование
	|";
	
	Результат = Запрос.Выполнить();
	
	ТекстНастройки = "";
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		ТекстНастройки = ТекстНастройки + Выборка.Шаблон + Символы.ПС + Символы.ПС;
	КонецЦикла;
	
	Возврат ТекстНастройки;
КонецФункции

Функция ПолучитьПредопределеныеШаблоны() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ТехнологическиеЖурналыШаблоны.Ссылка КАК ШаблонСсылка
	|ИЗ
	|	Справочник.ТехнологическиеЖурналыШаблоны КАК ТехнологическиеЖурналыШаблоны
	|ГДЕ
	|	ТехнологическиеЖурналыШаблоны.Предопределенный = ИСТИНА
	|	И ТехнологическиеЖурналыШаблоны.Ссылка <> &DUMP
	|УПОРЯДОЧИТЬ ПО
	|	ТехнологическиеЖурналыШаблоны.Наименование
	|";
	
	Запрос.УстановитьПараметр("DUMP", Справочники.ТехнологическиеЖурналыШаблоны.DUMP);	
	Результат = Запрос.Выполнить();
	
	ТекстНастройки = "";
	
	ШаблоныТЖ = Новый Массив;
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		ШаблоныТЖ.Добавить(Выборка.ШаблонСсылка);
	КонецЦикла;
	
	Возврат ШаблоныТЖ;
КонецФункции

Функция ПолучитьПредопределенныйФайлНастроек() Экспорт
	ТекстНастройки = ПолучитьПредопределеныеНастройки();
	
	ТекстНастройки = 
		"<?xml version=""1.0""?>" + Символы.ПС +
		"<config xmlns=""http://v8.1c.ru/v8/tech-log"">" + Символы.ПС + Символы.ПС +
		ТекстНастройки + "</config>";
		
	Возврат ТекстНастройки;
КонецФункции

Функция ИмяПредопределенного(Ссылка)
	Возврат Справочники.ТехнологическиеЖурналыШаблоны.ПолучитьИмяПредопределенного(Ссылка);
КонецФункции

Функция ШаблонATTN()
	Шаблон = 
	"<log location=""[Каталог логов]\ATTN"" history=""4"">
	|	<event>
	|		<eq property=""Name"" value=""ATTN""/>
	|	</event>
	|	<property name=""all""/>
	|</log>";
	
	Возврат Шаблон;
КонецФункции

Функция ШаблонCALL()
	Шаблон = 
	"<log location=""[Каталог логов]\CALL"" history=""4"">
	|	<event>
	|		<eq property=""Name"" value=""CALL""/>
	|		<ge property=""Duration"" value=""10000""/>
	|	</event>
	|	<property name=""all""/>
	|</log>";
	
	Возврат Шаблон;
КонецФункции

Функция ШаблонCONN()
	Шаблон = 
	"<log location=""[Каталог логов]\CONN"" history=""4"">
	|	<event>
	|		<eq property=""Name"" value=""CONN""/>
	|	</event>
	|	<property name=""Context"">
	|		<event>
	|			<eq property=""name"" value=""""/>
	|		</event>
	|	</property>
	|	<property name=""all""/>
	|</log>";
	
	Возврат Шаблон;
КонецФункции

Функция ШаблонDataBaseException()
	Шаблон = 
	"<log location=""[Каталог логов]\DataBaseException"" history=""4"">
	|	<event>
	|		<eq property=""Name"" value=""EXCP""/>
	|		<eq property=""Exception"" value=""DataBaseException""/>
	|	</event>
	|	<property name=""all""/>
	|</log>";
	
	Возврат Шаблон;
КонецФункции

Функция ШаблонDB()
	Шаблон = 
	"<log location=""[Каталог логов]\DB"" history=""4"">
	|	<event>
	|		<eq property=""Name"" value=""DBMSSQL""/>
	|		<ge property=""Duration"" value=""10000""/>
	|	</event>
	|	<event>
	|		<eq property=""Name"" value=""DBORACLE""/>
	|		<ge property=""Duration"" value=""10000""/>
	|	</event>
	|	<event>
	|		<eq property=""Name"" value=""DB2""/>
	|		<ge property=""Duration"" value=""10000""/>
	|	</event>
	|	<event>
	|		<eq property=""Name"" value=""DBPOSTGRS""/>
	|		<ge property=""Duration"" value=""10000""/>
	|	</event>
	|	<property name=""all""/>
	|</log>";
	
	Возврат Шаблон;
КонецФункции

Функция ШаблонDUMP()
	Шаблон = 
	"<dump create=""true"" location=""[Каталог логов]\DUMPS"" type=""3"" prntscrn=""false""/>";
	
	Возврат Шаблон;
КонецФункции

Функция ШаблонEXCP()
	Шаблон = 
	"<log location=""[Каталог логов]\EXCP"" history=""4"">
	|	<event>
	|		<eq property=""Name"" value=""EXCP""/>
	|	</event>
	|	<property name=""all""/>
	|</log>";
	
	Возврат Шаблон;
КонецФункции

Функция ШаблонPROC()
	Шаблон = 
	"<log location=""[Каталог логов]\PROC"" history=""4"">
	|	<event>
	|		<eq property=""Name"" value=""PROC""/>
	|	</event>
	|	<property name=""Context"">
	|		<event>
	|			<eq property=""name"" value=""""/>
	|		</event>
	|	</property>
	|	<property name=""all""/>
	|</log>";
	
	Возврат Шаблон;
КонецФункции

Функция ШаблонRetExcp()
	Шаблон = 
	"<log location=""[Каталог логов]\ClientException"" history=""4"">
	|	<event>
	|		<ne property=""RetExcp"" value=""""/>
	|	</event>
	|	<property name=""Context"">
	|		<event>
	|			<eq property=""name"" value=""""/>
	|		</event>
	|	</property>
	|	<property name=""all""/>
	|</log>";
	
	Возврат Шаблон;
КонецФункции

Функция ШаблонSDBL()
	Шаблон = 
	"<log location=""[Каталог логов]\CommitTransaction"" history=""4"">
	|	<event>
	|		<eq property=""Name"" value=""SDBL""/>
	|		<like property=""Func"" value=""CommitTransaction""/>
	|		<ge property=""Duration"" value=""10000""/>
	|	</event>
	|	<property name=""all""/>
	|</log>";
	
	Возврат Шаблон;
КонецФункции

Функция ШаблонSESN()
	Шаблон = 
	"<log location=""[Каталог логов]\SESN"" history=""4"">
	|	<event>
	|		<eq property=""Name"" value=""SESN""/>
	|		<eq property=""Func"" value=""Start""/>
	|	</event>
	|	<event>
	|		<eq property=""Name"" value=""SESN""/>
	|		<eq property=""Func"" value=""Finish""/>
	|	</event>
	|	<property name=""all""/>
	|</log>";
	
	Возврат Шаблон;
КонецФункции

Функция ШаблонTDEADLOCK()
	Шаблон = 
	"<log location=""[Каталог логов]\Tlockerr"" history=""4"">
	|	<event>
	|		<eq property=""Name"" value=""TTIMEOUT""/>
	|	</event>
	|	<event>
	|		<eq property=""Name"" value=""TDEADLOCK""/>
	|	</event>
	|</log>";
	
	Возврат Шаблон;
КонецФункции

Функция ШаблонTLOCK()
	Шаблон = 
	"<log location=""[Каталог логов]\Tlock"" history=""4"">
	|	<event>
	|		<eq property=""Name"" value=""TLOCK""/>
	|		<ge property=""Duration"" value=""10000""/>
	|	</event>
	|	<property name=""Context"">
	|		<event>
	|			<eq property=""name"" value=""""/>
	|		</event>
	|	</property>
	|	<property name=""all""/>
	|</log>";
	
	Возврат Шаблон;
КонецФункции

#КонецЕсли
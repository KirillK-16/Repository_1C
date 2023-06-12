#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
// Общие настройки
Перем ТекстОшибки;
Перем ЗадачаОшибкаПриАнализе;
Перем ОбязательныеНастройки;
Перем НетПроблем;
Перем ИмяСтраницыСправки;

// Настройки контрольной процедуры
Перем КаталогЭкспорта;
Перем КаталогДампов;
Перем КаталогВыгрузкиДамповСетевой;
Перем КаталогНастроекТЖ;
Перем КаталогТЖСетевой;
Перем КаталогТЖЛокальный;
Перем УровеньДетализацииДампов;
Перем ДлительностьХраненияФайловТЖ;
Перем ЧислоДампов;
Перем ИмяКомпьютера;
Перем КаталогВременныхФайлов;
Перем Кластер;
Перем АвтоматическаяНастройка;
Перем ИспользоватьАгента;

//////////////////////
// Общие функции
//////////////////////



Процедура ПроверкаНаНаличиеОшибокВыполнения(ТочкаМаршрутаБизнесПроцесса, Результат)
	Результат = ТекстОшибки <> Неопределено;
КонецПроцедуры

Процедура КонтрольнаяПроцедураЗавершенаПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Результат = НЕ КонтрольнаяПроцедура.Выполнять;
КонецПроцедуры

//////////////////
// Разбор Настроек
//////////////////

Процедура ЕстьНезаполненныеНастройкиПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Ошибки = Новый Массив;
	Для Каждого Настройка Из ОбязательныеНастройки Цикл		
		Если НЕ ЗначениеЗаполнено(Настройка.Значение) Тогда
			Ошибки.Добавить(Настройка.Ключ);
		КонецЕсли;
	КонецЦикла;	
	Если Ошибки.Количество() > 0 Тогда
		ТекстОшибки = "Для контролируемого рабочего сервера требуется указать следующие настройки: "; 	
		ТекстОшибки = ТекстОшибки + Символы.ПС + " - " + ОбщийКлиентСервер.ОбъединитьСтроку(Ошибки, Символы.ПС + " - ");
		Результат = Истина;
		ИмяСтраницыСправки = "НеЗаполненыНастройкиВОбъектеКонтроля";

	Иначе	
		Результат = Ложь;
	КонецЕсли;
		
КонецПроцедуры

Процедура РазобратьНастройкиОбработка(ТочкаМаршрутаБизнесПроцесса)
	ТекстОшибки = Неопределено;
	
	Попытка
		РазобратьНастройки();
	Исключение
		
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ИмяСтраницыСправки = "НеизвестнаяОшибка";
		Отладка.Ошибка(ТекстОшибки);
		
	КонецПопытки;
КонецПроцедуры

Процедура РазобратьНастройки()
	ОбязательныеНастройки = Новый Соответствие;
	
	НастройкиСловарь = РегистрыСведений.ПараметрыРабочихСерверов.Получить(
		Новый Структура("ОбъектКонтроля", КонтрольнаяПроцедура.ОбъектКонтроля)
	);
    
    ЧастныеНастройкиСловарь = РегистрыСведений.НастройкиСборДампов.Получить(Новый Структура("КонтрольнаяПроцедура", КонтрольнаяПроцедура));
    
    Если ЧастныеНастройкиСловарь.АвтоматическаяНастройка И НЕ ЧастныеНастройкиСловарь.ИспользоватьАгента Тогда
        КаталогНастроекТЖ = НастройкиСловарь.КаталогНастроекТЖ;
        ОбязательныеНастройки.Вставить("Имя каталога файла настройки технологического журнала (logcfg.xml)", КаталогНастроекТЖ);
    КонецЕсли;
	
	ИмяКомпьютера = НастройкиСловарь.Оборудование.Наименование;
	Кластер = НастройкиСловарь.Кластер;
		
	УстановитьПривилегированныйРежим(Истина);
	ДанныеХранилища = РегистрыСведений.БезопасноеХранилище.ПолучитьДанные(КонтрольнаяПроцедура);
	ЧастныеНастройкиСловарь.Вставить("КаталогЭкспортаДампов", ДанныеХранилища.КаталогЭкспортаДампов);
	УстановитьПривилегированныйРежим(Ложь);
	
	КаталогЭкспорта = ЧастныеНастройкиСловарь.КаталогЭкспортаДампов;
	
	КаталогТЖСетевой = Общий.УникальныйКаталогДляКонтрольнойПроцедуры(КонтрольнаяПроцедура, ЧастныеНастройкиСловарь.КаталогТЖСетевой);
	КаталогТЖЛокальный = ЧастныеНастройкиСловарь.КаталогТЖЛокальный;
	ДлительностьХраненияФайловТЖ = ЧастныеНастройкиСловарь.ДлительностьХраненияФайловТЖ;
	КаталогДампов = ЧастныеНастройкиСловарь.КаталогВыгрузкиДампов;
	КаталогВыгрузкиДамповСетевой = ЧастныеНастройкиСловарь.КаталогВыгрузкиДамповСетевой;
	КаталогВременныхФайлов = ЧастныеНастройкиСловарь.КаталогВременныхФайлов;
	УровеньДетализацииДампов = ЧастныеНастройкиСловарь.УровеньДетализацииДампов;
	АвтоматическаяНастройка = ЧастныеНастройкиСловарь.АвтоматическаяНастройка;
    ИспользоватьАгента = ЧастныеНастройкиСловарь.ИспользоватьАгента; 
	
КонецПроцедуры

/////////////////////
// Формирование задач
/////////////////////

Функция СоздатьЗадачуОтветственномуЗаВыполнение(ТекстПоручения)
	
	Возврат Неопределено;
	
КонецФункции	

Процедура СформироватьСписокЗадач(ФормируемыеЗадачи, ЗадачаСсылка, ТочкаМаршрутаБизнесПроцесса)
	ФормируемыеЗадачи.Очистить();		
	
	ЗадачаОбъект = ЗадачаСсылка.ПолучитьОбъект();
	Если ЗадачаОбъект.БизнесПроцесс = Неопределено И ЗадачаОбъект.ТочкаМаршрута = Неопределено Тогда 
		БизнесПроцессСервер.ПривязатьЗадачуКТочкеМаршрута(ЭтотОбъект.Ссылка, ЗадачаОбъект, ТочкаМаршрутаБизнесПроцесса);	
	КонецЕсли;
	ЗадачаОбъект.Выполнена = Ложь;
	ФормируемыеЗадачи.Добавить(ЗадачаОбъект);
	
КонецПроцедуры	

Процедура УстранитьПричиныНевозможностиАнализаПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЗадачаОшибкаПриАнализе = СоздатьЗадачуОтветственномуЗаВыполнение(ТекстОшибки);
	СформироватьСписокЗадач(ФормируемыеЗадачи, ЗадачаОшибкаПриАнализе, ТочкаМаршрутаБизнесПроцесса);
КонецПроцедуры

Процедура НачатьПроверкуПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	//здесь надо переиспользовать задачу
	ЗадачаПоПерезапуску = БизнесПроцессСервер.НайтиЗадачуПерезапуска(ЭтотОбъект.Ссылка);
	СформироватьСписокЗадач(ФормируемыеЗадачи, ЗадачаПоПерезапуску, ТочкаМаршрутаБизнесПроцесса);
КонецПроцедуры

////////////////////////
// Анализ
////////////////////////

Процедура ВыполнитьАнализОбработка(ТочкаМаршрутаБизнесПроцесса)
	
	ТекстОшибки = Неопределено;
    Попытка
        Если НЕ ИспользоватьАгента Тогда
            ВыполнитьАнализ();
        КонецЕсли;
	Исключение
		НетПроблем = Неопределено;
		ИмяСтраницыСправки = "НеизвестнаяОшибка";
		Сообщение = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Отладка.Ошибка(Сообщение);
		СоздатьЗадачуОтветственномуЗаВыполнение(Сообщение);
	КонецПопытки;

КонецПроцедуры	

Функция ПроверкаПовторяющихсяДампов(ТекущийФайлДампа, ТекущаяДата)
	Результат = Ложь;
	
	ПовторяющиесяДампы = СборДамповСервер.ВыборкаДампов(ТекущийФайлДампа.Имя, КонтрольнаяПроцедура.ОбъектКонтроля);
	
	Если ПовторяющиесяДампы.Следующий() Тогда
		ДатаПервогоОбнаружения = ПовторяющиесяДампы.Период;
		ВремяОжиданияУдаления = Константы.КритическийСрокХраненияДампаМин.Получить();
		Если ТекущаяДата - ДатаПервогоОбнаружения > ВремяОжиданияУдаления * 60 Тогда
			// Это значит, что ранее при разборе дампов
			// что-то пошло не так и программа не смогла удалить файл:
			// либо ошибка возникла при удалении, либо вообще на подступах
			// к строчке кода удаления файла.
			
			// Предлагается, дамп не трогать, а ответственного за сбор дампов
			// проинформировать, что появились "странные" дампы, 
			// которые разобрались
			
			ИмяСтраницыСправки = "СборДамповНайденФайлБывшийВОбработке";
			Сообщение = НСтр("ru = 'Дамп %1 не удаляется уже больше %2 минут'");
			Сообщение = СтрЗаменить(Сообщение, "%1", ТекущийФайлДампа.Имя);
			Сообщение = СтрЗаменить(Сообщение, "%2", ВремяОжиданияУдаления);
						
		КонецЕсли;
		Результат = Истина;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Процедура ВыполнитьАнализ()
    
    Если ИспользоватьАгента Тогда
        НетПроблем = Истина;
	    Возврат;
    КонецЕсли;
        
	НастроитьГенерациюДампов();
	
	НетПроблем = Истина;
	ТекущаяДата = ТекущаяДата();
	
	КаталогПроверка = Новый Файл(КаталогВыгрузкиДамповСетевой);
	Если КаталогПроверка.Существует() Тогда
		ФайлыДампов = НайтиФайлыДампов();
	Иначе
		Сообщение = "Не найден каталог сбора дампов """ + КаталогВыгрузкиДамповСетевой + """!";
		НетПроблем = Ложь;
		Возврат;
	КонецЕсли;
	
	//// Варианты дампа на самом деле относятся ни к контретному серверу, а к информационной системе в целом.
	//// Не имеет значения на каком сервере образовался вариант дампа.
	//// Исключительная табличная блокировка накладывается для предотвращения
	//// параллельного чтения. Первый процесс, который не обнаружил нужный
	//// вариант дампа создаст его.		
	//
	//БлокировкаДанных = Новый БлокировкаДанных;
	//ЭлементБлокировки = БлокировкаДанных.Добавить("Справочник.ВариантыДампов");
	//ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	//БлокировкаДанных.Заблокировать();
	ЧислоДампов = 0;
	
	ИдентификаторыДампов = Новый Массив;
	РегистрируемыеДампы = Новый Массив;
	
	Для Каждого ТекущийФайлДампа Из ФайлыДампов Цикл
		
		СтруктураИмениФайла = СборДамповСервер.РазобратьИмяФайлаДампа(ТекущийФайлДампа);
		ИдентификаторыДампов.Добавить(СтруктураИмениФайла.PID);
		
		ДампыСОшибкой = СборДамповСервер.ВыборкаДамповЗавершениеОшибкой(ТекущийФайлДампа.Имя, КонтрольнаяПроцедура.ОбъектКонтроля);
		Если ДампыСОшибкой.Следующий() Тогда
			Сообщение = Строка(ДампыСОшибкой.СостояниеОбработкиДампа) + ": " + ДампыСОшибкой.ОписаниеОшибки;
		КонецЕсли;
		
		Если ПроверкаПовторяющихсяДампов(ТекущийФайлДампа, ТекущаяДата) Тогда
			Продолжить;
		КонецЕсли;
		
		ТекстУведомленияОДампе = НСтр("ru = 'На сервере %1 обнаружен дамп. Тип процесса: %2'");
		ТекстУведомленияОДампе = СтрЗаменить(ТекстУведомленияОДампе, "%1", Строка(КонтрольнаяПроцедура.ОбъектКонтроля));
		ТекстУведомленияОДампе = СтрЗаменить(ТекстУведомленияОДампе, "%2", Строка(СтруктураИмениФайла.Процесс));
		Общий.ЗаписатьВЖурналКонтроля(
			ЧислоСообщений, 
			КонтрольнаяПроцедура, 
			Перечисления.ЗаголовкиЖурналаКонтроля.Предупреждение, 
			ТекстУведомленияОДампе
		);
		
		
		НетПроблем = Ложь;
		
		РезультатыАнализа = СборДамповСервер.ВыполнитьАнализДампа(СтруктураИмениФайла, КаталогЭкспорта);
		Если РезультатыАнализа.ВидДампа = Перечисления.РезультатыАнализаДампов.НовыйВариантДампа Тогда
			СостояниеОбработкиДампа = Перечисления.СостоянияОбработкиДампа.ЗарегистрированоСозданиеДампа;
			ОписаниеПоручения = Справочники.ТипыЗадачСборДампов.СборДамповНовыйДампРассмотреть.ДополнительныйТекстПредупреждения;
			
			ИмяДампа = СтрЗаменить(ТекущийФайлДампа.Имя, ".mdmp", "");
			ИмяДампа = СтрЗаменить(ИмяДампа, "_", Символы.ПС);
			
			ИмяПроцесса = СтрПолучитьСтроку(ИмяДампа, 1);
			Платформа = СтрПолучитьСтроку(ИмяДампа, 2);
			Смещение = СтрПолучитьСтроку(ИмяДампа, 3);
			ДатаДампа = СтрПолучитьСтроку(ИмяДампа, 4);
			Процесс = СтрПолучитьСтроку(ИмяДампа, 5);
			
			ОписаниеПоручения = БизнесПроцессСервер.УстановитьДатуВШаблоне(ОписаниеПоручения, "Дата=", ТекущаяДата());
			ОписаниеПоручения = СтрЗаменить(ОписаниеПоручения, "[ИмяПроцесса]", ИмяПроцесса);
			ОписаниеПоручения = СтрЗаменить(ОписаниеПоручения, "[Платформа]", Платформа);
			ОписаниеПоручения = СтрЗаменить(ОписаниеПоручения, "[Смещение]", Смещение);
			ОписаниеПоручения = БизнесПроцессСервер.УстановитьДатуВШаблоне(ОписаниеПоручения, "ДатаДампа=", Дата(ДатаДампа));
			ОписаниеПоручения = СтрЗаменить(ОписаниеПоручения, "[Процесс]", Процесс);
			
		ИначеЕсли РезультатыАнализа.ВидДампа = Перечисления.РезультатыАнализаДампов.ДубльИсправленногоДампа Тогда
			СостояниеОбработкиДампа = Перечисления.СостоянияОбработкиДампа.ЗарегистрированоСозданиеДампа;
			ОписаниеПоручения = НСтр("ru = 'Рассмотреть дамп %1'");
			ОписаниеПоручения = СтрЗаменить(ОписаниеПоручения, "%1", ТекущийФайлДампа.Имя);
			
		Иначе
			СостояниеОбработкиДампа = Перечисления.СостоянияОбработкиДампа.ЗарегистрированоСозданиеДампаДляУдаления;
		КонецЕсли;
		
		ПИДстрока = Формат(СтруктураИмениФайла.PID, "ЧГ=0");
		РасположениеТЖ = ОбщийКлиентСервер.СкорректироватьПуть(КаталогТЖСетевой) + "\" + СтруктураИмениФайла.ИмяПроцесса + "_" + ПИДстрока;
		Если НайтиФайлы(РасположениеТЖ).Количество() = 0 Тогда
			ИмяСтраницыСправки = "СборДамповНеНайденТЖ";
			Сообщение = НСтр("ru = 'Не найден технологический журнал процесса %ТипПроцесса (pid %PID).'");
			Сообщение = СтрЗаменить(Сообщение, "%ТипПроцесса", СтруктураИмениФайла.ИмяПроцесса);
			Сообщение = СтрЗаменить(Сообщение, "%PID", ПИДстрока);
			РасположениеТЖ = "";
		КонецЕсли;
		
		ЧислоДампов = ЧислоДампов + 1;
		РегистрируемыйДамп = Новый Структура();
		РегистрируемыйДамп.Вставить("Период", ТекущаяДата);
		РегистрируемыйДамп.Вставить("ВариантДампа", РезультатыАнализа.ВариантДампа);
		РегистрируемыйДамп.Вставить("ОбъектКонтроля", КонтрольнаяПроцедура.ОбъектКонтроля);
		РегистрируемыйДамп.Вставить("ИмяФайлаДампа", ТекущийФайлДампа.Имя);
		РегистрируемыйДамп.Вставить("НомерДампа", ЧислоДампов);
		РегистрируемыйДамп.Вставить("КаталогЭкспорта", КаталогЭкспорта);
		РегистрируемыйДамп.Вставить("РасположениеТЖ", РасположениеТЖ);
		РегистрируемыйДамп.Вставить("ИмяБезРасширения", ТекущийФайлДампа.ИмяБезРасширения);
		РегистрируемыйДамп.Вставить("ПолноеИмя", ТекущийФайлДампа.ПолноеИмя);
		РегистрируемыйДамп.Вставить("КаталогВременныхФайлов", КаталогВременныхФайлов);
		РегистрируемыйДамп.Вставить("СостояниеОбработкиДампа", СостояниеОбработкиДампа);
		РегистрируемыйДамп.Вставить("РазмерФайла", 0);
		РегистрируемыеДампы.Добавить(РегистрируемыйДамп);
	КонецЦикла;
	
	ЗапросЗамеченныхПроцессов = Новый Запрос;
	ЗапросЗамеченныхПроцессов.Текст = "ВЫБРАТЬ
	|	МониторингПроцессов.Процесс,
	|	МАКСИМУМ(МониторингПроцессов.Время) КАК ДатаПадения
	|ИЗ
	|	РегистрСведений.МониторингПроцессов КАК МониторингПроцессов
	|ГДЕ
	|	МониторингПроцессов.Сервер = &Сервер
	|	И МониторингПроцессов.Время >= &Время
	|	И МониторингПроцессов.Кластер = &Кластер
	|
	|СГРУППИРОВАТЬ ПО
	|	МониторингПроцессов.Процесс
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаПадения";
	ЗапросЗамеченныхПроцессов.УстановитьПараметр("Сервер", ИмяКомпьютера);
	ЗапросЗамеченныхПроцессов.УстановитьПараметр("Время", РегистрыСведений.ВременнойГоризонтПросмотраДампов.Получить(
		Новый Структура("КонтрольнаяПроцедура", КонтрольнаяПроцедура)
	)["Дата"]);
	ЗапросЗамеченныхПроцессов.УстановитьПараметр("Кластер", Кластер);
	ВыборкаЗамеченныхПроцессов = ЗапросЗамеченныхПроцессов.Выполнить().Выбрать();
	
	ЗавершившиесяПроцессы = Новый Соответствие;
	МаксВремяПадения = Неопределено;
	Пока ВыборкаЗамеченныхПроцессов.Следующий() Цикл
		ДатаПадения = ВыборкаЗамеченныхПроцессов.ДатаПадения;
		PID = ВыборкаЗамеченныхПроцессов.Процесс;
		Если МаксВремяПадения = Неопределено Тогда
			МаксВремяПадения = ДатаПадения;
		Иначе
			МаксВремяПадения = Макс(ДатаПадения, МаксВремяПадения);
		КонецЕсли;
		СписокПроцессов = ЗавершившиесяПроцессы.Получить(ДатаПадения);
		Если СписокПроцессов = Неопределено Тогда
			СписокПроцессов = Новый Массив;
			ЗавершившиесяПроцессы.Вставить(ДатаПадения, СписокПроцессов);
		КонецЕсли;
		Попытка
			СписокПроцессов.Добавить(PID);
		Исключение
			// не записался pid
			Инфо = ИнформацияОбОшибке();
			Комментарий =
				"Описание = '" +Инфо.Описание + "', " +
				"ИмяМодуля = '" + Инфо.ИмяМодуля + "', " +
				"НомерСтроки = '" + Инфо.НомерСтроки + "', " +
				"ИсходнаяСтрока = '" + Инфо.ИсходнаяСтрока + "'.";
			
			ЗаписьЖурналаРегистрации(
				"Процедура ВыполнитьАнализ()",
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.БизнесПроцессы.СборДампов.МодульОбъекта,
				,
				Комментарий);
		КонецПопытки;
	КонецЦикла;
	
	Если МаксВремяПадения <> Неопределено Тогда
		// самые молодые процессы могли не завершиться, поэтому дампы по ним будем искать
		// когда контрольная процедура сработает в следующий раз
		ЗавершившиесяПроцессы.Удалить(МаксВремяПадения);
		
		// Запоминаем новый временной горизонт
		ЗаписьОНовомГоризонте = РегистрыСведений.ВременнойГоризонтПросмотраДампов.СоздатьМенеджерЗаписи();
		ЗаписьОНовомГоризонте.Дата = МаксВремяПадения;
		ЗаписьОНовомГоризонте.КонтрольнаяПроцедура = КонтрольнаяПроцедура;
		ЗаписьОНовомГоризонте.Записать();
	КонецЕсли;
	
	// Так как мы не можем быть уверены, что последние записи в 
	// регистре сведений МониторингПроцессов соответствуют завершенным процессам
	// мы на текущей итерации их не рассматриваем.
	// Поэтому нужно поднять историю по дампам за прошлый раз.
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	МАКСИМУМ(Период) КАК ПериодМаксимум
	|ПОМЕСТИТЬ
	|	ВТ_Максимум
	|ИЗ
	|	РегистрСведений.Дампы КАК РегСвДампы
	|ГДЕ
	|	РегСвДампы.ОбъектКонтроля = &ОбъектКонтроля
	|;
	|ВЫБРАТЬ
	|	РегСвДампы.ИмяФайлаДампа КАК ИмяФайлаДампа, 
	|	РегСвДампы.ИмяБезРасширения КАК ИмяБезРасширения 
	|ИЗ
	|	ВТ_Максимум КАК ВТ_Максимум
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	РегистрСведений.Дампы КАК РегСвДампы
	|ПО
	|	РегСвДампы.Период = ВТ_Максимум.ПериодМаксимум
	|	И РегСвДампы.ОбъектКонтроля = &ОбъектКонтроля
	|";
	Запрос.УстановитьПараметр("ОбъектКонтроля", КонтрольнаяПроцедура.ОбъектКонтроля);
	Результат = Запрос.Выполнить();
	ЗаписьОДампе = Результат.Выбрать();
	
	Пока ЗаписьОДампе.Следующий() Цикл
		Попытка 
			СтруктураИмениФайла = СборДамповСервер.РазобратьИмяФайлаДампаПоИмени(
				ЗаписьОДампе.ИмяФайлаДампа, 
				ЗаписьОДампе.ИмяБезРасширения
			);
			ИдентификаторыДампов.Добавить(СтруктураИмениФайла.PID);
		Исключение
			// попалась запись о ТЖ без дампа
		КонецПопытки;
	КонецЦикла;
	
	// просматриваем список всех завершившихся процессов и
	// ищем соответствующий дамп, если дамп не обнаружен, тогда
	// производим оповещение
	Для Каждого ДатаСписокПроцессов Из ЗавершившиесяПроцессы Цикл
		ДатаПадения = ДатаСписокПроцессов.Ключ;
		СписокПроцессов = ДатаСписокПроцессов.Значение;
		Для Каждого PID Из СписокПроцессов Цикл
			Если ИдентификаторыДампов.Найти(PID) = Неопределено Тогда
				
				// Не каждое завершение процесса кластера является аварийным. Если технологический журнал процесса rphost заканчивается событием PROC вида
				// 27:00.0732-0,PROC,2,process=rphost,Err=0,Txt=1C:Enterprise 8.2 (x86-64) (8.2.18.102) Working Process (debug) terminated.
				// или журнал rmngr 
				// 27:00.1662-0,PROC,1,process=rmngr,Err=0,Txt=1C:Enterprise 8.2 (x86-64) (8.2.18.102) Cluster Manager (debug) finished.
				// или журнал ragent
				// 27:03.5080-0,PROC,1,process=ragent,Err=0,Txt=1C:Enterprise 8.2 (x86-64) (8.2.18.102) Server Agent (debug) finished.
				//где в поле Err указан 0, то проблемы никакой нет. Если же такое событие в тех журнале завершившегося процесса отсутствует, 
				// то это свидетельствует о возможном аварийном завершении процесса.
				// 
				ПИДстрока = Формат(PID, "ЧГ=0");
				РасположениеТЖ = ОбщийКлиентСервер.СкорректироватьПуть(КаталогТЖСетевой) + "\" + "rphost_" + ПИДстрока;
				ФайлыСЛогами = НайтиФайлы(РасположениеТЖ, "*.log");
				// читаем последний из файлов и ищем в его конце запись о завершении без ошибок
				ПоследнийФайлСЛогами = Неопределено;
				Для Каждого ФайлСЛогами Из ФайлыСЛогами Цикл
					Если ПоследнийФайлСЛогами = Неопределено ИЛИ ФайлСЛогами.Имя > ПоследнийФайлСЛогами.Имя Тогда
						ПоследнийФайлСЛогами = ФайлСЛогами;
					КонецЕсли;
				КонецЦикла;
				
				// Смотрим в конец файла
				Если ПоследнийФайлСЛогами = Неопределено Тогда
					// оповестить ответственного, что в папке с логами
					// процесса пусто
					
					ИмяСтраницыСправки = "СборДамповФайлыЛоговНеНайдены";
					Сообщение = Справочники.ТипыЗадачСборДампов.КаталогЛоговЗавершившегосяПроцессаПуст;
					Сообщение = БизнесПроцессСервер.УстановитьДатуВШаблоне(Сообщение, "Дата=", ТекущаяДата);
					Сообщение = СтрЗаменить(Сообщение, "[Процесс]", ПИДстрока);
					
					Продолжить;
				КонецЕсли;
				
				Логи = Новый ЧтениеТекста(ПоследнийФайлСЛогами.ПолноеИмя);
				ПоследняяСтрока = Неопределено;
				Пока Истина Цикл
					ТекущаяСтрока = Логи.ПрочитатьСтроку();
					Если ТекущаяСтрока = Неопределено Тогда
						Прервать;
					КонецЕсли;
					ПоследняяСтрока = ТекущаяСтрока;
				КонецЦикла;
				
				Если ПоследняяСтрока = Неопределено Тогда
					// оповестить ответственного, что в файл с 
					// логами пустой
					ИмяСтраницыСправки = "СборДамповФайлыЛоговПустой";
					Сообщение = НСтр("ru = 'Файл с логами процесса rphost (pid %PID) пуст.'");
					Сообщение = СтрЗаменить(Сообщение, "%PID", ПИДстрока);
					
					Продолжить;
				КонецЕсли;
				
				Если СтрЧислоВхождений(ПоследняяСтрока, "PROC") > 0 
					И СтрЧислоВхождений(ПоследняяСтрока, "Err=0") > 0
					И (СтрЧислоВхождений(ПоследняяСтрока, "finished") > 0 ИЛИ СтрЧислоВхождений(ПоследняяСтрока, "terminated") > 0)
				Тогда
					// процесс завершился успешно и никакой ошибки тут нет.
					Продолжить;
				КонецЕсли;
				
				// процесс завершился без дампа
				ИмяСтраницыСправки = "СборДамповНетДампа";
				НаименованиеПроцесса = "%ТипПроцесса (pid %PID)";
				НаименованиеПроцесса = СтрЗаменить(НаименованиеПроцесса, "%ТипПроцесса", "rphost");
				НаименованиеПроцесса = СтрЗаменить(НаименованиеПроцесса, "%PID", ПИДстрока);
				
				Сообщение = НСтр("ru = 'Рабочий процесс %НаименованиеПроцесса аварийно завершился без образования дампа. Технологический журнал сохранен в каталог %КаталогЭкспорта.'");
				Сообщение = СтрЗаменить(Сообщение, "%НаименованиеПроцесса", НаименованиеПроцесса);
				Сообщение = СтрЗаменить(Сообщение, "%КаталогЭкспорта", КаталогЭкспорта);
				
				РегистрируемыйДамп = Новый Структура();
				РегистрируемыйДамп.Вставить("Период", ТекущаяДата);
				РегистрируемыйДамп.Вставить("ВариантДампа", Справочники.ВариантыДампов.ДляЗавершенияБезОбразованияДампа);
				РегистрируемыйДамп.Вставить("ОбъектКонтроля", КонтрольнаяПроцедура.ОбъектКонтроля);
				РегистрируемыйДамп.Вставить("ИмяФайлаДампа", СборДамповСервер.ДампНеНайденВСтроку());
				РегистрируемыйДамп.Вставить("НомерДампа", ЧислоДампов);
				РегистрируемыйДамп.Вставить("КаталогЭкспорта", КаталогЭкспорта);
				РегистрируемыйДамп.Вставить("РасположениеТЖ", РасположениеТЖ);
				РегистрируемыйДамп.Вставить("ИмяБезРасширения", СтрЗаменить("Технологический журнал процесса %НаименованиеПроцесса", "%НаименованиеПроцесса", НаименованиеПроцесса));
				РегистрируемыйДамп.Вставить("ПолноеИмя", "");
				РегистрируемыйДамп.Вставить("КаталогВременныхФайлов", "");
				РегистрируемыйДамп.Вставить("СостояниеОбработкиДампа", Перечисления.СостоянияОбработкиДампа.ДампНеНайден);
				РегистрируемыйДамп.Вставить("РазмерФайла", 0);
			
				РегистрируемыеДампы.Добавить(РегистрируемыйДамп);
				ЧислоДампов = ЧислоДампов + 1;
				
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Для Каждого РегистрируемыйДамп Из РегистрируемыеДампы Цикл
		СборДамповСервер.ЗарегистрироватьФайлДампа(РегистрируемыйДамп);
	КонецЦикла;
	
	НетПроблемWindowsErrorReporting = ЗарегистрироватьДампыWindowsErrorReporting(ТекущаяДата);
	
	Если НетПроблем Тогда
		НетПроблем = НетПроблемWindowsErrorReporting;
	КонецЕсли;
КонецПроцедуры

Функция ЗарегистрироватьДампыWindowsErrorReporting(ТекущаяДата)
	НетПроблемWindowsErrorReporting = Истина;
	
	ФайлыДампов = НайтиФайлы(КаталогВыгрузкиДамповСетевой, "*.dmp", Ложь);
	
	РегистрируемыеДампы = Новый Массив;
	
	Для Каждого ТекущийФайлДампа Из ФайлыДампов Цикл
		СтруктураИмениФайла = Новый Структура("Процесс, ИмяПроцесса, ВерсияПлатформы, Смещение, ДатаВремя, PID, ИмяДампа, ПолноеИмя, ИмяФайлаБезРасширения");
		СтруктураИмениФайла = ЗаполнитьСтруктуруWindowsErrorReporting(ТекущийФайлДампа, СтруктураИмениФайла);
		
		Если ПроверкаПовторяющихсяДампов(ТекущийФайлДампа, ТекущаяДата) Тогда
			Продолжить;
		КонецЕсли;
				
		ВариантДампа = СборДамповСервер.НайтиВариантДампа(СтруктураИмениФайла);
		Если ВариантДампа = Неопределено Тогда
			СостояниеОбработкиДампа = Перечисления.СостоянияОбработкиДампа.ЗарегистрированоСозданиеДампа;
			ИмяZIPДампаПриЭкспорте = СборДамповСервер.ИмяZIPДампаПриЭкспорте(КаталогЭкспорта, ТекущийФайлДампа.ИмяБезРасширения, ТекущийФайлДампа.Расширение);
			ВариантДампа = СборДамповСервер.СоздатьВариантДампа(СтруктураИмениФайла, ИмяZIPДампаПриЭкспорте, Истина);
		КонецЕсли;
		
		ОписаниеПоручения = Справочники.ТипыЗадачСборДампов.СборДамповНовыйДампРассмотреть.ДополнительныйТекстПредупреждения;
		
		ИмяДампа = СтрЗаменить(ТекущийФайлДампа.Имя, ".dmp", "");
				
		ИмяПроцесса = СтруктураИмениФайла.ИмяПроцесса;
		Платформа = СтруктураИмениФайла.ВерсияПлатформы;
		Смещение =СтруктураИмениФайла.Смещение;
		ДатаДампа = СтруктураИмениФайла.ДатаВремя;
		Процесс = СтруктураИмениФайла.Процесс;
		
		ОписаниеПоручения = БизнесПроцессСервер.УстановитьДатуВШаблоне(ОписаниеПоручения, "Дата=", ТекущаяДата());
		ОписаниеПоручения = СтрЗаменить(ОписаниеПоручения, "[ИмяПроцесса]", ИмяПроцесса);
		ОписаниеПоручения = СтрЗаменить(ОписаниеПоручения, "[Платформа]", Платформа);
		ОписаниеПоручения = СтрЗаменить(ОписаниеПоручения, "[Смещение]", Смещение);
		ОписаниеПоручения = БизнесПроцессСервер.УстановитьДатуВШаблоне(ОписаниеПоручения, "ДатаДампа=", Дата(ДатаДампа));
		ОписаниеПоручения = СтрЗаменить(ОписаниеПоручения, "[Процесс]", Процесс);
			
		РегистрируемыйДамп = Новый Структура();
		РегистрируемыйДамп.Вставить("Период", ТекущаяДата);
		РегистрируемыйДамп.Вставить("ВариантДампа", ВариантДампа);
		РегистрируемыйДамп.Вставить("ОбъектКонтроля", КонтрольнаяПроцедура.ОбъектКонтроля);
		РегистрируемыйДамп.Вставить("ИмяФайлаДампа", ТекущийФайлДампа.Имя);
		РегистрируемыйДамп.Вставить("НомерДампа", 1);
		РегистрируемыйДамп.Вставить("КаталогЭкспорта", КаталогЭкспорта);
		РегистрируемыйДамп.Вставить("РасположениеТЖ", "");
		РегистрируемыйДамп.Вставить("ИмяБезРасширения", ТекущийФайлДампа.ИмяБезРасширения);
		РегистрируемыйДамп.Вставить("ПолноеИмя", ТекущийФайлДампа.ПолноеИмя);
		РегистрируемыйДамп.Вставить("КаталогВременныхФайлов", КаталогВременныхФайлов);
		РегистрируемыйДамп.Вставить("СостояниеОбработкиДампа", Перечисления.СостоянияОбработкиДампа.ЗарегистрированоСозданиеДампа);
		РегистрируемыйДамп.Вставить("РазмерФайла", 0);
		РегистрируемыеДампы.Добавить(РегистрируемыйДамп);
	КонецЦикла;
	
	Для Каждого РегистрируемыйДамп Из РегистрируемыеДампы Цикл
		СборДамповСервер.ЗарегистрироватьФайлДампа(РегистрируемыйДамп);
		НетПроблемWindowsErrorReporting = Ложь;
	КонецЦикла;
	
	Возврат НетПроблемWindowsErrorReporting;
КонецФункции

Функция ЗаполнитьСтруктуруWindowsErrorReporting(Файл, СтруктураИмениФайла)
	Если СтрНайти(Файл.ИмяБезРасширения, "rmngr.exe") > 0 Тогда
		ИмяБезРасширенияМассив = СтрРазделить(Файл.ИмяБезРасширения, ".", Ложь);
		ИмяПроцесса = "rmngr_wer";
		
		СтруктураИмениФайла.Процесс = СборДамповКонстантыСервер.ТипУпавшегоПроцесса(ИмяПроцесса);
		СтруктураИмениФайла.ИмяПроцесса = ИмяПроцесса;
		СтруктураИмениФайла.ВерсияПлатформы = ВерсияПлатформыСервер.ВерсияПлатформы("0.0.0.0");
		СтруктураИмениФайла.Смещение = "00000000";
		СтруктураИмениФайла.ДатаВремя = Файл.ПолучитьВремяИзменения();
		СтруктураИмениФайла.PID = Число(ИмяБезРасширенияМассив[2]);
		СтруктураИмениФайла.ИмяДампа = ВРег(СтруктураИмениФайла.ИмяПроцесса + "_" + СтруктураИмениФайла.ВерсияПлатформы + "_" + СтруктураИмениФайла.Смещение);
		СтруктураИмениФайла.ПолноеИмя = Файл.ПолноеИмя;
		СтруктураИмениФайла.ИмяФайлаБезРасширения = Файл.ИмяБезРасширения;
	ИначеЕсли СтрНайти(Файл.ИмяБезРасширения, "rphost.exe") > 0 Тогда
		ИмяБезРасширенияМассив = СтрРазделить(Файл.ИмяБезРасширения, ".", Ложь);
		ИмяПроцесса = "rphost_wer";
		
		СтруктураИмениФайла.Процесс = СборДамповКонстантыСервер.ТипУпавшегоПроцесса(ИмяПроцесса);
		СтруктураИмениФайла.ИмяПроцесса = ИмяПроцесса;
		СтруктураИмениФайла.ВерсияПлатформы = ВерсияПлатформыСервер.ВерсияПлатформы("0.0.0.0");
		СтруктураИмениФайла.Смещение = "00000000";
		СтруктураИмениФайла.ДатаВремя = Файл.ПолучитьВремяИзменения();
		СтруктураИмениФайла.PID = Число(ИмяБезРасширенияМассив[2]);
		СтруктураИмениФайла.ИмяДампа = ВРег(СтруктураИмениФайла.ИмяПроцесса + "_" + СтруктураИмениФайла.ВерсияПлатформы + "_" + СтруктураИмениФайла.Смещение);
		СтруктураИмениФайла.ПолноеИмя = Файл.ПолноеИмя;
		СтруктураИмениФайла.ИмяФайлаБезРасширения = Файл.ИмяБезРасширения;
	Иначе
		СтруктураИмениФайла.Процесс = Перечисления.Процессы.WindowsErrorReporting;
		СтруктураИмениФайла.ИмяПроцесса = Файл.ИмяБезРасширения;
		СтруктураИмениФайла.ВерсияПлатформы = ВерсияПлатформыСервер.ВерсияПлатформы("0.0.0.0");
		СтруктураИмениФайла.Смещение = "00000000";
		СтруктураИмениФайла.ДатаВремя = Файл.ПолучитьВремяИзменения();
		СтруктураИмениФайла.PID = 0;
		СтруктураИмениФайла.ИмяДампа = ВРег(СтруктураИмениФайла.ИмяПроцесса + "_" + СтруктураИмениФайла.ВерсияПлатформы + "_" + СтруктураИмениФайла.Смещение);
		СтруктураИмениФайла.ПолноеИмя = Файл.ПолноеИмя;
		СтруктураИмениФайла.ИмяФайлаБезРасширения = Файл.ИмяБезРасширения;
	КонецЕсли;
	
	Возврат СтруктураИмениФайла;
КонецФункции

////////////////////////
// Вспомогательные Функции
////////////////////////

Функция НайтиФайлыДампов()
	 
	ФайлыДампов = НайтиФайлы(КаталогВыгрузкиДамповСетевой, "*.mdmp", Ложь);
	Возврат ФайлыДампов;
	
КонецФункции	

Процедура НастроитьГенерациюДампов()
	
	Если НЕ (ЗначениеЗаполнено(КаталогТЖСетевой) И ЗначениеЗаполнено(КаталогТЖЛокальный) И ЗначениеЗаполнено(КаталогНастроекТЖ)) Тогда
		Возврат;
	КонецЕсли;
	
	Параметры = Новый Структура;
	Параметры.Вставить("СборДампов", Новый Массив);
	Параметры.СборДампов.Добавить("УровеньДетализацииДампов");
	Параметры.СборДампов.Добавить("КаталогВыгрузкиДампов");
	
	ТехнологическийЖурнал.ОбновитьФайлНастроекТехнологическогоЖурнала(КонтрольнаяПроцедура.ОбъектКонтроля, Новый Структура("КодыКонтрольныхПроцедур",Параметры));
		
КонецПроцедуры

#КонецЕсли








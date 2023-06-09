
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
Перем ТекстОшибкиДатаСовпадаетСТекущей;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БазыСохранены = ЗагрузитьНастройки();
	Выборка = Общий.ВыборкаИнформационныхБаз();
	Пока Выборка.Следующий() Цикл
		ИБ = Выборка.Ссылка;
		Элементы.СписокИнформационныхБазИнформационнаяБаза.СписокВыбора.Добавить(ИБ);
		Если НЕ БазыСохранены Тогда
			СтрокаИнформационнойБазы = СписокИнформационныхБаз.Добавить();
			СтрокаИнформационнойБазы.ИнформационнаяБаза = ИБ;
		КонецЕсли;
	КонецЦикла;
	
	ИнициализироватьДиаграмму();
	ОбновитьДиаграмму();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ТекстОшибкиДатаСовпадаетСТекущей = "Ошибка! %ИнтервалНеОкончен!";
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	ПроверяемыеРеквизиты.Добавить("СписокИнформационныхБаз.ИнформационнаяБаза");
	НомерСтроки = 0;
	Для Каждого СтрокаИнформационнойБазы Из СписокИнформационныхБаз Цикл
		Если СтрокаИнформационнойБазы.ИнформационнаяБаза.Пустая() Тогда
			Отказ = Истина;
			
			ОбщийКлиентСервер.СгенерироватьСообщениеПользователю(
				"Информационная база не выбрана!",
				"СписокИнформационныхБаз[" + НомерСтроки + "].ИнформационнаяБаза",
				ЭтотОбъект
			);
		КонецЕсли;
		НомерСтроки = НомерСтроки + 1;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СписокИнформационныхБазПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	ЗапрещенныеИнформационныеБазы = ТекущийСписокИнформационныхБаз();
	ОписаниеОповещения = Новый ОписаниеОповещения("СписокИнформационныхБазПередНачаломДобавленияЗавершение", ЭтотОбъект);
	ПараметрыОткрытия = Новый Структура("ЗапрещенныеИнформационныеБазы", ЗапрещенныеИнформационныеБазы);
	ОткрытьФорму("Справочник.ОбъектыКонтроля.Форма.ФормаВыбораИнформационнойБазы", ПараметрыОткрытия,,,,,ОписаниеОповещения);

	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокИнформационныхБазПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Если РезультатЗакрытия <> Неопределено Тогда
		СтрокаБазы = СписокИнформационныхБаз.Добавить();
		СтрокаБазы.ИнформационнаяБаза = РезультатЗакрытия;
		ЭтотОбъект.ГрафикДоступности.Очистить();
		ЭтотОбъект.Элементы.СписокИнформационныхБаз.ТекущаяСтрока = СтрокаБазы.ПолучитьИдентификатор();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	ЭтотОбъект.ГрафикДоступности.Очистить();
КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеПриИзменении(Элемент)
	ЭтотОбъект.ГрафикДоступности.Очистить();
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ВыбранноеЗначение >= ДатаОкончания Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьПредупреждение(,"Ошибка! Дата начала должна быть раньше " + Формат(ДатаОкончания, "ДФ=""дд ММММ гггг""") + ".");
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ВыбранноеЗначение <= ДатаНачала Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьПредупреждение(,"Ошибка! Дата окончания должна быть позднее " + Формат(ДатаНачала, "ДФ=""дд ММММ гггг""") + ".");
		Возврат;
	КонецЕсли;
	
	ПроверкаЧтоТекущийИнтервалОкончен(ВыбранноеЗначение, ИнтервалУсреднения, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалУсредненияПриИзменении(Элемент)
	ОбновитьДиаграммуКлиент();
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалУсредненияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ПроверкаЧтоТекущийИнтервалОкончен(ДатаОкончания, ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура СписокИнформационныхБазПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ЭтотОбъект.ГрафикДоступности.Очистить();
КонецПроцедуры

&НаКлиенте
Процедура СписокИнформационныхБазПослеУдаления(Элемент)
	ЭтотОбъект.ГрафикДоступности.Очистить();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Обновить(Команда)
	ОбновитьДиаграммуКлиент();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОбновитьДиаграммуКлиент()
	
	Если ПроверитьЗаполнение() Тогда
		ТекущийИнтервалОкончен = ПроверкаЧтоТекущийИнтервалОкончен(ДатаОкончания, ИнтервалУсреднения);
		Если НЕ ТекущийИнтервалОкончен Тогда
			Возврат;
		КонецЕсли;
		ОбновитьДиаграмму();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция НачалоИнтервала(ДатаВИнтервале, ИнтервалУсредненияНаГрафике)
	Если ИнтервалУсредненияНаГрафике = ПредопределенноеЗначение("Перечисление.ИнтервалыУсреднения.День") Тогда
		Возврат НачалоДня(ДатаВИнтервале);
	ИначеЕсли ИнтервалУсредненияНаГрафике = ПредопределенноеЗначение("Перечисление.ИнтервалыУсреднения.Неделя") Тогда
		Возврат НачалоНедели(ДатаВИнтервале);
	ИначеЕсли ИнтервалУсредненияНаГрафике = ПредопределенноеЗначение("Перечисление.ИнтервалыУсреднения.Месяц") Тогда
		Возврат НачалоМесяца(ДатаВИнтервале);
	Иначе
		ВызватьИсключение НСтр("ru = 'Неверно выбран интервал усреднения.'");
	КонецЕсли;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция КонецИнтервала(ДатаВИнтервале, ИнтервалУсредненияНаГрафике)
	Если ИнтервалУсредненияНаГрафике = ПредопределенноеЗначение("Перечисление.ИнтервалыУсреднения.День") Тогда
		Возврат КонецДня(ДатаВИнтервале);
	ИначеЕсли ИнтервалУсредненияНаГрафике = ПредопределенноеЗначение("Перечисление.ИнтервалыУсреднения.Неделя") Тогда
		Возврат КонецНедели(ДатаВИнтервале);
	ИначеЕсли ИнтервалУсредненияНаГрафике = ПредопределенноеЗначение("Перечисление.ИнтервалыУсреднения.Месяц") Тогда
		Возврат КонецМесяца(ДатаВИнтервале);
	Иначе
		ВызватьИсключение НСтр("ru = 'Неверно выбран интервал усреднения.'");
	КонецЕсли;
КонецФункции

&НаКлиенте
Функция ПроверкаЧтоТекущийИнтервалОкончен(ДатаОкончанияПроверка, ИнтервалУсредненияПроверка, СтандартнаяОбработка = Неопределено)
	
	ТекущаяДата = ТекущаяДата();
	Если ИнтервалУсредненияПроверка = ПредопределенноеЗначение("Перечисление.ИнтервалыУсреднения.День") Тогда
		ДатаОкончанияПриведенная = КонецДня(ДатаОкончанияПроверка);
		ТекстОшибки = "Текущий день ещё не окончен! Дата окончания должна быть раньше " +  Формат(НачалоДня(ТекущаяДата), "ДФ=""дд ММММ гггг""") + ".";
	ИначеЕсли ИнтервалУсредненияПроверка = ПредопределенноеЗначение("Перечисление.ИнтервалыУсреднения.Неделя") Тогда
		ДатаОкончанияПриведенная = КонецНедели(ДатаОкончанияПроверка);
		ТекстОшибки = "Текущая неделя ещё не окончена! Дата окончания должна быть раньше " +  Формат(НачалоНедели(ТекущаяДата), "ДФ=""дд ММММ гггг""") + ".";
	ИначеЕсли ИнтервалУсредненияПроверка = ПредопределенноеЗначение("Перечисление.ИнтервалыУсреднения.Месяц") Тогда
		ДатаОкончанияПриведенная = КонецМесяца(ДатаОкончанияПроверка);
		ТекстОшибки = "Текущий месяц ещё не окончен! Дата окончания должна быть раньше " +  Формат(НачалоМесяца(ТекущаяДата), "ДФ=""дд ММММ гггг""") + ".";
	Иначе
		ВызватьИсключение НСтр("ru = 'Неверно выбран интервал усреднения.'");
	КонецЕсли;
	
	Если ТекущаяДата() < ДатаОкончанияПриведенная Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьПредупреждение(,СтрЗаменить(ТекстОшибкиДатаСовпадаетСТекущей, "%ИнтервалНеОкончен", ТекстОшибки));
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ИнициализироватьДиаграмму()
	ГрафикДоступности.Обновление = Ложь;
	ГрафикДоступности.ТипДиаграммы = ТипДиаграммы.Гистограмма;
	ГрафикДоступности.ОтображатьЛегенду = Ложь; 
	ГрафикДоступности.ОбластьПостроения.Право = 1;
	ГрафикДоступности.ОбластьПостроения.Рамка = Новый Рамка(
		ТипРамкиЭлементаУправления.Одинарная, 
		1
	);
	ГрафикДоступности.ОбластьПостроения.ОтображатьШкалу = Истина;
	ГрафикДоступности.ОбластьПостроения.ОтображатьПодписиШкалыТочек = Истина; 
	
	ГрафикДоступности.ОбластьПостроения.ОриентацияМеток = ОриентацияМетокДиаграммы.Авто;
	ГрафикДоступности.АвтоУстановкаТекстаТочек = Ложь;
	ГрафикДоступности.ПропускатьБазовоеЗначение = Ложь;
	ГрафикДоступности.РазделительПодписей = ", ";
	ГрафикДоступности.АвтоМинимальноеЗначение = Ложь;
	ГрафикДоступности.Обновление = Истина;
КонецПроцедуры

&НаСервере
Процедура ОбновитьДиаграмму()
	СохранитьНастройки();
	
	ИнформационныеБазыВМассив = Новый Массив;
	Для Каждого СтрокаБазы Из СписокИнформационныхБаз Цикл
		ИнформационнаяБаза = СтрокаБазы.ИнформационнаяБаза;
		Если ИнформационныеБазыВМассив.Найти(ИнформационнаяБаза) = Неопределено Тогда
			ИнформационныеБазыВМассив.Добавить(ИнформационнаяБаза);
		КонецЕсли;
	КонецЦикла;
	
	Если ИнформационныеБазыВМассив.Количество() = 0 Тогда
		ГрафикДоступности.Очистить();
		Возврат;
	КонецЕсли;
	
	РезультатВыборки = КонтрольПодключенийСервер.ВыборкаСостоянийЗаПериод(
		НачалоИнтервала(ДатаНачала, ИнтервалУсреднения),
		КонецИнтервала(ДатаОкончания, ИнтервалУсреднения),
		ИнформационныеБазыВМассив
	);
	
	ВыборкаСостояний = РезультатВыборки.ВыборкаСостояний;
	ВесаИнформационныхБаз = РезультатВыборки.ВесаИнформационныхБаз;
	Результат = РезультатВыборки.Результат;
	
	// Инициализируем блоки данных для расчёта процента доступности
	БлокиДанныхПоБазам = Новый Соответствие;
	Для Каждого ТекИнфБаза Из ВесаИнформационныхБаз Цикл
		БлокиДанных = Новый Массив;
		
		СекундВИнтервалеУсреднения = МониторингСервер.СекундВИнтервалеУсреднения(ИнтервалУсреднения);
		ФорматПредставленияДаты = "ДФ=""дд ММММ гггг """;
		
		ДатаНачалаКонецИнтервала = КонецИнтервала(ДатаНачала, ИнтервалУсреднения);
		ДатаОкончанияКонецИнтервала = КонецИнтервала(ДатаОкончания, ИнтервалУсреднения);
		иДата = ДатаНачалаКонецИнтервала;
		Пока иДата <= ДатаОкончанияКонецИнтервала Цикл
			иДатаНачала = НачалоИнтервала(иДата, ИнтервалУсреднения);
			БлокиДанных.Добавить(Новый Структура(
			"ДатаНачала, ДатаОкончания, Значение, ТекущаяПозиция, ТекущееСостояние",
			иДатаНачала,
			иДата,
			0,
			иДатаНачала,
			Неопределено
			));
			иДата = КонецИнтервала(иДатаНачала + СекундВИнтервалеУсреднения, ИнтервалУсреднения);
		КонецЦикла;
		
		БлокиДанныхПоБазам.Вставить(ТекИнфБаза.Ключ, БлокиДанных);
	КонецЦикла;
		
	МинимальныйИндексБлока = 0;
	ЧислоБлоков = БлокиДанных.Количество();
	ЧислоБаз = ВесаИнформационныхБаз.Количество();

	ТекущаяИБ = Неопределено;
	Пока ВыборкаСостояний.Следующий() Цикл
		БлокиДанных = БлокиДанныхПоБазам[ВыборкаСостояний.ИнформационнаяБаза];
		
		ДатаСобытия = ВыборкаСостояний.Время;
		ИБ = ВыборкаСостояний.ИнформационнаяБаза;
		Состояние = ВыборкаСостояний.ТекущееЗначение;
		
		ИндексБлока = МинимальныйИндексБлока;
		Пока ИндексБлока < ЧислоБлоков Цикл
			Блок = БлокиДанных[ИндексБлока];
			
			Если ДатаСобытия >= Блок.ДатаНачала И ДатаСобытия <= Блок.ДатаОкончания Тогда
				Блок.ТекущееСостояние = Состояние;
				
				Блок.Значение = Блок.Значение + (1 - Блок.ТекущееСостояние) * (ДатаСобытия - Блок.ТекущаяПозиция);
				Блок.ТекущаяПозиция = ДатаСобытия;
			КонецЕсли;
			ИндексБлока = ИндексБлока + 1;
		КонецЦикла;
	КонецЦикла;
	
	БлокиДанныхДляВывода = Новый Соответствие;
	ТаблицаПериодов = Новый ТаблицаЗначений;
	ТаблицаПериодов.Колонки.Добавить("ДатаНачала");
	ТаблицаПериодов.Колонки.Добавить("ДатаОкончания");
	
	Для Каждого ТекИнфБаза Из ВесаИнформационныхБаз Цикл
		БлокиДанныхТемп = БлокиДанныхПоБазам[ТекИнфБаза.Ключ];
		
		Для ТекИндексБлока = 0 По БлокиДанныхТемп.ВГраница() Цикл
			Блок = БлокиДанныхТемп[ТекИндексБлока];
			
			Если ТекИндексБлока = 0 И Блок.ТекущееСостояние = Неопределено Тогда
				Блок.ТекущееСостояние = 0;
			КонецЕсли;
						
			КлючБлока = Новый СтандартныйПериод(Блок.ДатаНачала, Блок.ДатаОкончания);
			
			Если БлокиДанныхДляВывода[КлючБлока] = Неопределено Тогда
				БлокиДанныхДляВывода.Вставить(КлючБлока, 0);
				
				НовСтрока = ТаблицаПериодов.Добавить();
				НовСтрока.ДатаНачала = Блок.ДатаНачала;
				НовСтрока.ДатаОкончания = Блок.ДатаОкончания;
			КонецЕсли;
			
						
			Если Блок.ТекущееСостояние = Неопределено Тогда
				Блок.ТекущееСостояние = БлокиДанныхТемп[ТекИндексБлока - 1].ТекущееСостояние;
			КонецЕсли;
			
			Блок.Значение = Блок.Значение + Блок.ТекущееСостояние * (Блок.ДатаОкончания - Блок.ТекущаяПозиция);
			
			БлокиДанныхДляВывода[КлючБлока] = БлокиДанныхДляВывода[КлючБлока] + ОКР(((Блок.Значение/(Блок.ДатаОкончания + 1 - Блок.ДатаНачала)) * 100) * ТекИнфБаза.Значение, 2);
		КонецЦикла;
	КонецЦикла;
	
	ТаблицаПериодов.Сортировать("ДатаНачала, ДатаОкончания");
	
	а = 1;
	
	БлокиДанных = Новый Массив;
	МинимальноеЗначение = 90;
	Для Каждого ТекСтрока Из ТаблицаПериодов Цикл
		КлючБлока = Новый СтандартныйПериод(ТекСтрока.ДатаНачала, ТекСтрока.ДатаОкончания); 
		Блок = Новый Структура("ДатаНачала, ДатаОкончания, Значение, Текст");
		
		Блок.ДатаНачала = НачалоДня(ТекСтрока.ДатаНачала);
		Блок.ДатаОкончания = НачалоДня(ТекСтрока.ДатаОкончания);
		Блок.Значение = БлокиДанныхДляВывода[КлючБлока];
		
		Если Блок.Значение < МинимальноеЗначение Тогда
			МинимальноеЗначение = Блок.Значение;
		КонецЕсли;
		
		Блок.Текст = МониторингКлиентСервер.ТекстПодсказки(
						"Процент доступности информационных баз", 
						МониторингКлиентСервер.ПодписьДиапазонаВВидеИнтервала(
							Блок.ДатаНачала,
							Блок.ДатаОкончания, 
							ФорматПредставленияДаты),
						Блок.Значение,);
						
		БлокиДанных.Добавить(Блок);
	КонецЦикла;
	
	МинимальноеЗначение = Цел(МинимальноеЗначение/10) * 10;
	
	// выводим данные на диаграмму
	
	ГрафикДоступности.Обновление = Ложь;
	ГрафикДоступности.ОтображатьЗаголовок = Ложь;
	
	Если ЭтотОбъект.АвтоминимальноеЗначение Тогда
		ГрафикДоступности.БазовоеЗначение = МинимальноеЗначение;
		ГрафикДоступности.МинимальноеЗначение = МинимальноеЗначение;
	КонецЕсли;
	
		
	ГрафикДоступности.Очистить();
	МониторингКлиентСервер.НанестиТочкиДиапазонаВВидеИнтервалов(
		ГрафикДоступности, 
		БлокиДанных,
		ФорматПредставленияДаты
	);
	
	// Добавляем серию на диаграмму
	ИдентификаторСерии = "ДоступностьСерия";
	Серия = МониторингКлиентСервер.СерияПоЗначению(ГрафикДоступности, ИдентификаторСерии);
	ПараметрыСерии = Новый Структура;
	ПараметрыСерии.Вставить("Цвет",Новый Цвет(0, 176,  80));
	ПараметрыСерии.Вставить(
		"Линия", 
		МониторингКлиентСервер.Линия("Сплошная", 2)
	);
	ПараметрыСерии.Вставить("Маркер", ТипМаркераДиаграммы.Нет);
	ПараметрыСерии.Вставить("Значение", ИдентификаторСерии);
	МониторингКлиентСервер.ОбновитьСериюПоказателя(Серия, ПараметрыСерии);
	
	МониторингКлиентСервер.ВывестиНаГрафикеДанные(ГрафикДоступности, Серия, БлокиДанных, Неопределено);
	
	ГрафикДоступности.Обновление = Истина;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КлючНастроек()
	УникальныйИдентификаторПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().УникальныйИдентификатор;
	Возврат "НастройкиФормыПроцентДоступности_" + УникальныйИдентификаторПользователя;
КонецФункции

&НаСервере
Процедура СохранитьНастройки()
	КлючНастроек = КлючНастроек();
	ХранилищеНастроекДанныхФорм.Сохранить(КлючНастроек, "ДатаНачала", ДатаНачала);
	ХранилищеНастроекДанныхФорм.Сохранить(КлючНастроек, "ДатаОкончания", ДатаОкончания);
	ХранилищеНастроекДанныхФорм.Сохранить(КлючНастроек, "ИнтервалУсреднения", ИнтервалУсреднения);
	ХранилищеНастроекДанныхФорм.Сохранить(КлючНастроек, "АвтоминимальноеЗначение", АвтоминимальноеЗначение);
	
	СписокИнформационныхБазДанные = РеквизитФормыВЗначение("СписокИнформационныхБаз");
	ХранилищеНастроекДанныхФорм.Сохранить(КлючНастроек, "СписокИнформационныхБаз", СписокИнформационныхБазДанные);
КонецПроцедуры

&НаСервере
Функция ЗагрузитьНастройки()
	КлючНастроек = КлючНастроек();
	
	АвтоминимальноеЗначениеСохраненное = ХранилищеНастроекДанныхФорм.Загрузить(КлючНастроек, "АвтоминимальноеЗначение");
	Если НЕ ЗначениеЗаполнено(АвтоминимальноеЗначениеСохраненное) Тогда
		АвтоминимальноеЗначениеСохраненное = Ложь;
	КонецЕсли;
	АвтоминимальноеЗначение = АвтоминимальноеЗначениеСохраненное;
	
	ДатаНачалаСохраненная = ХранилищеНастроекДанныхФорм.Загрузить(КлючНастроек, "ДатаНачала");
	Если НЕ ЗначениеЗаполнено(ДатаНачалаСохраненная) Тогда
		ДатаНачалаСохраненная = ТекущаяДатаСеанса() - 3600 * 24 * 7;
	КонецЕсли;
	ДатаНачала = ДатаНачалаСохраненная;
	
	ДатаОкончанияСохраненная = ХранилищеНастроекДанныхФорм.Загрузить(КлючНастроек, "ДатаОкончания");
	Если НЕ ЗначениеЗаполнено(ДатаОкончанияСохраненная) Тогда
		ДатаОкончанияСохраненная = ТекущаяДатаСеанса() - 3600 * 24;
	КонецЕсли;
	ДатаОкончания = ДатаОкончанияСохраненная;
	
	ИнтервалУсреднения = ХранилищеНастроекДанныхФорм.Загрузить(КлючНастроек, "ИнтервалУсреднения");
	Если ИнтервалУсреднения.Пустая() Тогда
		ИнтервалУсреднения = Перечисления.ИнтервалыУсреднения.День;
	КонецЕсли;
	
	СписокИнформационныхБазДанные = ХранилищеНастроекДанныхФорм.Загрузить(КлючНастроек, "СписокИнформационныхБаз");
	БазыСохранены = СписокИнформационныхБазДанные <> Неопределено;
	Если БазыСохранены Тогда
		ЗначениеВРеквизитФормы(СписокИнформационныхБазДанные, "СписокИнформационныхБаз");
	КонецЕсли;
	
	Возврат БазыСохранены;
КонецФункции

&НаСервере
Функция ТекущийСписокИнформационныхБаз()
	ИнформационныеБазыВСписок = Новый СписокЗначений;
	Для Каждого СтрокаБазы Из СписокИнформационныхБаз Цикл
		ИнформационныеБазыВСписок.Добавить(СтрокаБазы.ИнформационнаяБаза);
	КонецЦикла;
	Возврат ИнформационныеБазыВСписок;
КонецФункции

&НаКлиенте
Процедура АвтоминимальноеЗначениеПриИзменении(Элемент)
	ЭтотОбъект.ГрафикДоступности.Очистить();
КонецПроцедуры









